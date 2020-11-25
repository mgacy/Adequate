//
//  DataProvider.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/28/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

#if canImport(WidgetKit)
import WidgetKit
#endif
import AWSAppSync
import AWSMobileClient
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise

class DataProvider: DataProviderType {
    typealias DealHistory = DealHistoryQuery.Data.DealHistory

    // TODO: before transitioning .result -> .loading we could store `Deal` to enable comparison with result
    // TODO: rename `ViewState<T>` as `ResourceState<T>`?
    private var dealState: ViewState<Deal> {
        didSet {
            // TODO: check that viewState != oldValue before calling completions?
            log.verbose("New dealState: \(dealState)")
            callObservations(with: dealState)
        }
    }

    private var historyState: ViewState<[DealHistory.Item]> {
        didSet {

            if case .result = historyState {
                log.verbose("New historyState: RESULT")
            } else {
                log.verbose("New historyState: \(historyState)")
            }

            callObservations(with: historyState)
        }
    }

    private let credentialsProvider: CredentialsProvider

    private let client: MehSyncClientType

    private let refreshManager: RefreshManager

    private var currentDealWatcher: GraphQLQueryWatcher<GetDealQuery>?

    private var dealObservations: [UUID: (ViewState<Deal>) -> Void] = [:]
    private var historyObservations: [UUID: (ViewState<[DealHistory.Item]>) -> Void] = [:]

    private var fetchCompletionObserver: CompletionWrapper<UIBackgroundFetchResult>?
    private var refreshHistoryObserver: CompletionWrapper<Void>?

    private var credentialsProviderIsInitialized: Bool = false

    // TODO: use a task queue (`OperationQueue`) for RefreshEvents / fetches? See `AWSPerformMutationQueue`
    private var pendingRefreshEvent: RefreshEvent?

    /// Token identifying request to run in background when app is launched in background from notification.
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    /// Reference to fetch query operation used to return current deal in response to background app refresh.
    private var cancellable: Cancellable? // FIXME: use better name

    // MARK: - Lifecycle

    init(credentialsProvider: CredentialsProvider) {
        self.dealState = .empty
        self.historyState = .empty
        self.credentialsProvider = credentialsProvider
        self.client = MehSyncClient(credentialsProvider: credentialsProvider)
        self.refreshManager = RefreshManager()

        // TODO: do work on another thread
        addDealObserver(self) { dp, viewState in
            guard case .result(let deal) = viewState, let currentDeal = CurrentDeal(deal: deal) else {
                return
            }
            let currentDealManager = CurrentDealManager()
            currentDealManager.saveDeal(currentDeal)

            // FIXME: we should really only reload for a change in status
            // FIXME: should this be run as a completion handler on CurrentDealManager.saveDeal() so we don't reload
            // until after it has saved?
            if #available(iOS 14, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }

        // TODO: should we indicate that we are in the process of initializing?
        log.debug("\(#function) - currentUserState: \(credentialsProvider.currentUserState)")
        credentialsProvider.initialize()
            .then { [weak self] userState in
                self?.credentialsProviderIsInitialized = true
                if let refreshEvent = self?.pendingRefreshEvent {
                    self?.refreshDeal(for: refreshEvent)
                    self?.pendingRefreshEvent = nil
                }
            }.catch { [weak self] error in
                log.error("Unable to initialize credentialsProvider: \(error)")
                self?.dealState = .error(error)
            }
    }

    init(credentialsProvider: CredentialsProvider, client: MehSyncClientType) {
        self.dealState = .empty
        self.historyState = .empty
        self.credentialsProvider = credentialsProvider
        self.client = client
        self.refreshManager = RefreshManager()

        addDealObserver(self) { dp, viewState in
            guard case .result(let deal) = viewState, let currentDeal = CurrentDeal(deal: deal) else {
                return
            }
            let currentDealManager = CurrentDealManager()
            currentDealManager.saveDeal(currentDeal)

            // FIXME: we should really only reload for a change in status
            if #available(iOS 14, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }

        switch credentialsProvider.currentUserState {
        case .unknown:
            credentialsProvider.initialize()
                .then { [weak self] userState in
                    self?.credentialsProviderIsInitialized = true
                    if let refreshEvent = self?.pendingRefreshEvent {
                        self?.refreshDeal(for: refreshEvent)
                        self?.pendingRefreshEvent = nil
                    }
                }.catch { [weak self] error in
                    log.error("Unable to initialize credentialsProvider: \(error)")
                    self?.dealState = .error(error)
                }
        case .guest:
            credentialsProviderIsInitialized = true
            if let refreshEvent = pendingRefreshEvent {
                refreshDeal(for: refreshEvent)
                pendingRefreshEvent = nil
            }
        case .signedIn:
            log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        case .signedOut:
            log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        case .signedOutFederatedTokensInvalid:
            log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        case .signedOutUserPoolsTokenInvalid:
            log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        }
    }

    // MARK: - CurrentDealWatcher Config

    // TODO: make throwing
    private func configureWatcher(cachePolicy: CachePolicy) {
        log.verbose("\(#function) - \(cachePolicy)")
        // TODO: verify credentialsProvider.currentUserState?
        guard credentialsProviderIsInitialized else {
            log.error("credentialsProvider not yet initialized")
            return
        }
        guard currentDealWatcher == nil else {
            log.error("currentDealWatcher has already been configured")
            // TODO: call `refetchCurrentDeal(showLoading:)`?
            return
        }
        // TODO: is it really necessary that dealState == ViewState.empty?
        // TODO: simply make changing dealState to .loading contingent on dealState rather than bailing?
        guard dealState == ViewState<Deal>.empty else {
            log.error(".dealState is not empty")
            return
        }

        switch cachePolicy {
        case .returnCacheDataAndFetch, .fetchIgnoringCacheData:
            refreshManager.update(.request)
        default:
            break
        }

        dealState = .loading
        do {
            currentDealWatcher = try client.watchCurrentDeal(cachePolicy: cachePolicy, queue: .main) { [unowned self] result in
                switch result {
                case .success(let envelope):
                    guard let deal = envelope.data else {
                        log.error("Query failed to return result.")
                        self.dealState = .empty
                        return
                    }
                    //log.verbose("Deal: \(deal)")

                    //self.refreshManager.update(.responseEnvelope(envelope))
                    if case .server = envelope.source {
                        self.refreshManager.update(.response(deal))
                    }

                    // Don't call `callObservations(with:)` in `currentDeal` setter if no changes
                    // TODO: should this just be handled in the setter itself?
                    if case .result(let oldDeal) = self.dealState, oldDeal == deal {
                        log.verbose("\(#function) - No change, bailing: OLD: \(oldDeal) - NEW: \(deal)")
                        return
                    }
                    self.dealState = .result(deal)
                case .failure(let error):
                    log.error("Error: \(error.localizedDescription)")
                    switch self.dealState {
                    case .result:
                        // TODO: should we display an error after initial configuration?
                        return
                    default:
                        self.dealState = .error(error)
                    }
                }
            }
        } catch {
            log.error("\(#function) - unable to watchCurrentDeal: \(error.localizedDescription)")
            self.dealState = .error(error)
        }
    }

    // MARK: - Refresh

    func refreshDeal(for event: RefreshEvent) {
        log.verbose("\(#function) - \(event)")

        guard credentialsProviderIsInitialized else {
            if let currentPendingRefreshEvent = pendingRefreshEvent {
                log.warning("AWSMobileClient not initialized - deferring RefreshEvent: \(event) - replacing: \(currentPendingRefreshEvent)")
                // TODO: add logic to determine whether the new event should replace the current one
                // TODO: wrap pending refreshEvents in wrapper containing `createdAt` so we can discard old ones?
                pendingRefreshEvent = event
            } else {
                log.verbose("AWSMobileClient not initialized - deferring RefreshEvent: \(event)")
                pendingRefreshEvent = event
            }
            return
        }

        // TODO: peform fetch with .returnCacheDataAndFetch if dealState is .error?
        switch event {
        case .manual:
            guard currentDealWatcher != nil else {
                log.error("\(#function) - \(event) - currentDealWatcher not configured)")
                // FIXME: this will also make a `CompletionWrapper` to refresh history; do we want that?
                refreshDeal(for: .launch)
                return
            }
            refetchCurrentDeal(showLoading: true)
        // App State
        case .launch:
            let cachePolicy = refreshManager.cacheCondition.cachePolicy

            // Update Deal history after fetching current Deal
            refreshHistoryObserver = makeRefreshHistoryObserver(cachePolicy: cachePolicy)

            configureWatcher(cachePolicy: cachePolicy)
        case .launchFromNotification:
            // TODO: use associated `DealDelta` value to determine response

            // TODO: should we first check `UIApplication.shared.backgroundRefreshStatus`?

            // NOTE: we might need to call this method earlier as this method requests the task
            // assertion asynchronously and the system might suspend the app before that assertion
            // is granted. We could request it at the beginning of this method, but that would
            // require some logic to check if we have already started a background task.
            backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "NotificationBackgroundTask") { () -> Void in
                self.endTask()
            }

            // TODO: improve handling
            // TODO: should we (a) configure watcher after fetching deal or (b) skip altogether?
            // - if it was merely a deal delta notification, there is still some value to cached data
            // TODO: use .returnCacheDataDontFetch and rely on notification fetching?
            // TODO: configure watcher in closure for .fetchCurrentDeal?
            configureWatcher(cachePolicy: .returnCacheDataDontFetch)  // or use .returnCacheDataElseFetch?

            // TODO: **if dealDelta.deltaType == .newDeal, call refreshDealInBackground() { _ in ... self.endTask() }
            cancellable = client.fetchCurrentDeal(cachePolicy: .fetchIgnoringCacheData, queue: .main) { result in
                switch result {
                case .success(let envelope):
                    //self.refreshManager.update(.response(newDeal))
                    self.dealState = envelope.data != nil ? .result(envelope.data!) : .empty
                case .failure(let error):
                    log.error("\(error)")
                }
                self.endTask()
            }

        case .foreground:
            guard currentDealWatcher != nil else {
                log.error("\(#function) - \(event) - currentDealWatcher not configured)")
                refreshDeal(for: .launch)
                return
            }
            // FIXME: under certain conditions, we should simply return if (1) last request succeeded
            // and (2) time interval since `lastDealResponse` < `minimumRefreshInterval`

            let cacheCondition = refreshManager.cacheCondition
            refetchCurrentDeal(showLoading: cacheCondition.showLoading)

        // Notifications
        case .foregroundNotification:
            guard currentDealWatcher != nil else {
                log.error("\(#function) - \(event) - currentDealWatcher not configured)")
                refreshDeal(for: .launch)
                return
            }

            // TODO: still refresh if backgroundRefreshStatus == .available?
            refetchCurrentDeal(showLoading: true)
        case .silentNotification(let completionHandler):
            refreshDealInBackground(fetchCompletionHandler: completionHandler)
        }
    }

    // MARK: - Update

    /// Update current Deal in response to background notification.
    /// - Parameters:
    ///   - delta: `DealDelta` representing the content of the notification.
    ///   - completionHandler: The block to execute when the download operation is complete. When calling this block,
    ///                        pass in the fetch result value that best describes the results of your download
    ///                        operation.
    func updateDealInBackground(_ delta: DealDelta,
                                fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        log.verbose("\(#function) - \(delta)")
        switch delta.deltaType {
        case .newDeal:
            switch dealState {
            case .loading:
                // TODO: check that `refreshManager.lastDealRequest` is recent (last 30 seconds?)
                // TODO: try to fetch from cache and see if that is the correct one?
                log.info("\(#function) - already fetching Deal; setting .fetchCompletionObserver")
                if fetchCompletionObserver != nil {
                    // TODO: log more information; what does RefreshManager have?
                    log.error("Replacing existing .fetchCompletionObserver")
                    // FIXME: should we be calling the associated completion handler
                }
                fetchCompletionObserver = makeBackgroundFetchObserver(completionHandler: completionHandler)
                return
            default:
                refreshDealInBackground(fetchCompletionHandler: completionHandler)
            }

        // DealDelta
        default:
            switch dealState {
            case .loading:
                log.info("\(#function) - already fetching Deal; setting .fetchCompletionObserver")
                if fetchCompletionObserver != nil {
                    // TODO: check that `refreshManager.lastDealRequest` is recent (last 30 seconds?)
                    log.error("Replacing existing .fetchCompletionObserver")
                    // FIXME: should we be calling the associated completion handler
                }
                fetchCompletionObserver = makeBackgroundFetchObserver(completionHandler: completionHandler)
            case .result(let currentDeal):
                do {
                    guard let updatedDeal = try delta.apply(to: currentDeal) else {
                        log.info("No changes from applying \(delta) to \(currentDeal)")
                        completionHandler(.noData)
                        return
                    }

                    client.updateCache(for: updatedDeal, delta: delta)
                        .then({ _ in
                            log.verbose("Updated cache")
                            // TODO: update `lastDealResponse`?
                            //refreshManager?.update(.response(updatedDeal))
                            completionHandler(.newData)
                        }).catch({ error in
                            log.error("Unable to update cache: \(error)")
                            completionHandler(.failed)
                        })
                } catch {
                    log.error("Error applying \(delta) to \(currentDeal): \(error); calling refreshDealInBackground()")
                    refreshDealInBackground(fetchCompletionHandler: completionHandler)
                }
            default:
                // TODO: refetch
                log.warning("Unable to apply \(delta) to \(dealState); calling refreshDealInBackground()")
                refreshDealInBackground(fetchCompletionHandler: completionHandler)
            }
        }
    }

    /// Refetch current Deal using `currentDealWatcher`.
    /// - Parameter showLoading: Pass `true` to change `currentDeal` to `.loading` before fetching; otherwise, pass
    ///                          `false`.
    private func refetchCurrentDeal(showLoading: Bool) {
        // TODO: verify credentialsProvider.currentUserState?
        guard credentialsProviderIsInitialized else {
            log.error("\(#function) - credentialsProvider has not been initialized")
            // TODO: try to initialze credentialsProvider again?
            return
        }
        guard let currentDealWatcher = currentDealWatcher else {
            log.error("\(#function) - currentDealWatcher not configured")
            configureWatcher(cachePolicy: .fetchIgnoringCacheData)
            return
        }

        // TODO: how to handle different dealStates?
        log.verbose("\(#function) - \(showLoading) - \(dealState)")

        if showLoading {
            dealState = .loading
        }

        refreshManager.update(.request)
        currentDealWatcher.refetch()
    }

    // TODO: rename `fetchDealInBackground()`

    /// Fetch current Deal from server in response to background notification.
    /// - Parameter completionHandler: The block to execute when the download operation is complete. When calling this
    ///                                block, pass in the fetch result value that best describes the results of your
    ///                                download operation.
    private func refreshDealInBackground(fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        log.verbose("\(#function)")
        // TODO: should we start a timer to ensure that the completionHandler is called within the next 30 - cushion seconds?

        // TEMP:
        if backgroundTask != .invalid {
            log.warning("\(#function) - backgroundTask appears to be in progress")
        }

        if !credentialsProviderIsInitialized {
            log.error("Trying to refresh Deal before initializing credentials provider")
            // TODO: check if we are replacing existing pendingRefreshEvent
            pendingRefreshEvent = .silentNotification(completionHandler)
            return
        }

        refreshManager.update(.request)
        // FIXME: this does not necessarily ensure we are not already fetching the current deal, since we may have
        // called `refreshDeal(showLoading: false, cachePolicy:)`
        guard dealState != ViewState<Deal>.loading else {
            // TODO: check RefreshManager.lastDealRequest to ensure it is a recent request
            log.debug("Already fetching Deal; setting .fetchCompletionObserver")
            if fetchCompletionObserver != nil {
                log.error("Replacing existing .fetchCompletionObserver")
            }
            fetchCompletionObserver = makeBackgroundFetchObserver(completionHandler: completionHandler)
            return
        }

        cancellable = client.fetchCurrentDeal(cachePolicy: .fetchIgnoringCacheData, queue: .main) { result in
            switch result {
            case .success(let envelope):
                guard let newDeal = envelope.data else {
                    log.error("BACKGROUND_APP_REFRESH: failed - Deal was nil")
                    //self.dealState = .error(SyncClientError.myError("Deal was nil")
                    completionHandler(.failed)
                    return
                }
                self.refreshManager.update(.response(newDeal))
                if case .result(let oldDeal) = self.dealState {
                    if oldDeal != newDeal {
                        log.debug("BACKGROUND_APP_REFRESH: newData")
                        // TODO: start background task to download first deal image
                        self.dealState = .result(newDeal)
                        completionHandler(.newData)
                    } else {
                        log.debug("BACKGROUND_APP_REFRESH: noData")
                        completionHandler(.noData)
                    }
                } else {
                    log.debug("BACKGROUND_APP_REFRESH: newData")
                    // TODO: start background task to download first deal image
                    self.dealState = .result(newDeal)
                    completionHandler(.newData)
                }
            case .failure(let error):
                log.error("BACKGROUND_APP_REFRESH: failed - \(error.localizedDescription)")
                //self.dealState = .error(error)
                completionHandler(.failed)
            }
        }
    }

    private func endTask() {
        log.debug("Cancelling background tasks ...")
        cancellable?.cancel() // TODO: do we need any logic to skip if fetch already completed?
        // TODO: check if case .dealState = .loading { // would this ever be the case?
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
}

// MARK: - Get
extension DataProvider {

    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal> {
        // This should't be used to fetch the currentDeal and performing this check introduces coupling with
        // `MehSyncClient`
        let cachePolicy: CachePolicy = id == MehSyncClient.Constants.currentDealID ?
            .fetchIgnoringCacheData : .returnCacheDataElseFetch
        return client.fetchDeal(withID: id,cachePolicy: cachePolicy)
            .then({ result -> GetDealQuery.Data.GetDeal in
                guard let deal = result.getDeal else {
                    throw SyncClientError.missingField(selectionSet: result)
                }
                return deal
            }).recover({ error in
                log.error("\(#function): \(error.localizedDescription)")
                throw error
            })
    }

    func getDealHistory() {
        // FIXME: decide on CachePolicy: .fetchIgnoringCacheData / .returnCacheDataAndFetch
        getDealHistory(cachePolicy: .fetchIgnoringCacheData)
    }

    // TODO: what is the memory cost for holding 60?
    private func getDealHistory(limit: Int = 60, nextToken: String? = nil, cachePolicy: CachePolicy = .fetchIgnoringCacheData) {
        log.debug("\(#function) - \(cachePolicy)")
        //guard historyState != ViewState<[DealHistory]>.loading else { return }

        historyState = .loading
        client.fetchDealHistory(limit: limit, nextToken: nextToken, cachePolicy: cachePolicy)
            .then { [weak self] result in
                // FIXME: how to handle this?
                guard let data = result.dealHistory else {
                    throw SyncClientError.missingField(selectionSet: result)
                }

                // FIXME: change schema so `items` is non-nullable?
                guard let items = data.items, !items.isEmpty else {
                    self?.historyState = .empty
                    return
                }

                self?.historyState = .result(items.compactMap { $0 })
            }.catch { error in
                log.error("\(#function): \(error.localizedDescription)")
                // TODO: always show error?
                self.historyState = .error(error)
            }
    }
}

// MARK: - Observers
extension DataProvider {

    @discardableResult
    func addDealObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, ViewState<Deal>) -> Void) -> ObservationToken {
        let id = UUID()
        dealObservations[id] = { [weak self, weak observer] state in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.dealObservations.removeValue(forKey: id)
                return
            }
            closure(observer, state)
        }

        closure(observer, dealState)
        return ObservationToken { [weak self] in
            self?.dealObservations.removeValue(forKey: id)
        }
    }

    func addHistoryObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, ViewState<[DealHistory.Item]>) -> Void) -> ObservationToken {
        let id = UUID()
        historyObservations[id] = { [weak self, weak observer] state in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.historyObservations.removeValue(forKey: id)
                return
            }
            closure(observer, state)
        }

        closure(observer, historyState)
        return ObservationToken { [weak self] in
            self?.historyObservations.removeValue(forKey: id)
        }
    }

    private func callObservations(with dealState: ViewState<Deal>) {
        dealObservations.values.forEach { observation in
            observation(dealState)
        }
    }

    private func callObservations(with dealState: ViewState<[DealHistory.Item]>) {
        historyObservations.values.forEach { observation in
            observation(dealState)
        }
    }

}

// MARK: - Refresh Observer Factory
extension DataProvider {

    private func makeBackgroundFetchObserver(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> CompletionWrapper<UIBackgroundFetchResult> {
        let observer = CompletionWrapper(wrapping: completionHandler) { [weak self] in
            self?.fetchCompletionObserver = nil
        }
        observer.observationToken = addDealObserver(observer) { wrapper, viewState in
            switch viewState {
            case .result:
                // TODO: ideally, we should store previous deal to decide between .newData / .noData
                log.debug("BACKGROUND_APP_REFRESH: newData")
                wrapper.complete(with: .newData)
            case .error:
                log.debug("BACKGROUND_APP_REFRESH: failed")
                wrapper.complete(with: .failed)
            case .empty:
                // FIXME: this is sometimes getting called as soon as we add the observer since the dealState is still .empty
                //log.debug("BACKGROUND_APP_REFRESH: noData")
                //wrapper.complete(with: .noData)
                break
            case .loading:
                // This is called immediately; ignore it
                break
            }
        }
        return observer
    }

    private func makeRefreshHistoryObserver(cachePolicy: CachePolicy) -> CompletionWrapper<Void> {
        let observer: CompletionWrapper<Void> = CompletionWrapper(wrapping: { }) { [weak self] in
            self?.refreshHistoryObserver = nil
        }
        observer.observationToken = addDealObserver(observer) { [weak self] wrapper, viewState in
            //log.debug("refreshHistoryObserver: \(viewState)")
            switch viewState {
            case .result:
                self?.getDealHistory(cachePolicy: cachePolicy)
                wrapper.complete(with: ())
            case .error:
                // TODO: should we complete, or wait for another successful refresh?
                wrapper.complete(with: ())
            default:
                break
            }
        }
        return observer
    }
}
