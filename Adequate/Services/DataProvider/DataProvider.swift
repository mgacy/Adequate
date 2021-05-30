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
import Combine
import AWSAppSync
import AWSMobileClient
import class Promise.Promise // avoid name collision with AWSAppSync.Promise
import CurrentDealManager

// swiftlint:disable cyclomatic_complexity file_length function_body_length type_body_length

class DataProvider: DataProviderType {
    typealias DealHistory = DealHistoryQuery.Data.DealHistory.Item

    // TODO: before transitioning .result -> .loading we could store `Deal` to enable comparison with result
    // TODO: rename `ViewState<T>` as `ResourceState<T>`?

    @Published private(set) var dealState: ViewState<Deal> = .empty
    var dealPublisher: Published<ViewState<Deal>>.Publisher { $dealState }

    @Published private(set) var historyState: ViewState<[DealHistory]> = .empty
    var historyPublisher: Published<ViewState<[DealHistory]>>.Publisher { $historyState }

    private let credentialsProvider: CredentialsProvider

    private let client: MehSyncClientType

    //private let queue: DispatchQueue

    private let currentDealManager: CurrentDealManaging

    private let refreshEventQueue: RefreshEventQueueType

    private let refreshManager: RefreshManaging

    private let dealFetchResultManager: FetchResultManager

    private var currentDealWatcher: GraphQLQueryWatching?

    private var credentialsProviderIsInitialized: Bool = false

    /// Token identifying request to run in background when app is launched in background from notification.
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    /// Reference to fetch query operation used to return current deal in response to background app refresh.
    private var currentDealOperation: AWSAppSync.Cancellable?

    // FIXME: this is ugly
    private var shouldRefreshWidget: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    convenience init(credentialsProvider: CredentialsProvider) {
        let client = MehSyncClient(credentialsProvider: credentialsProvider)
        self.init(credentialsProvider: credentialsProvider, client: client)
    }

    init(
        credentialsProvider: CredentialsProvider,
        client: MehSyncClientType,
        currentDealManager: CurrentDealManaging = CurrentDealManager(),
        refreshEventQueue: RefreshEventQueueType = RefreshEventQueue(),
        refreshManager: RefreshManaging = RefreshManager(),
        dealFetchResultManager: FetchResultManager = FetchResultManager()
        //queue: DispatchQueue = DispatchQueue(label: "com.mgacy.data_provider", qos: .userInitiated)
    ) {
        self.credentialsProvider = credentialsProvider
        self.client = client
        self.currentDealManager = currentDealManager
        self.refreshEventQueue = refreshEventQueue
        self.refreshManager = refreshManager
        self.dealFetchResultManager = dealFetchResultManager
        //self.queue = queue

        dealFetchResultManager.configure(with: $dealState)

        #if DEBUG
        $dealState.logSink(id: "dealState")
            .store(in: &cancellables)
        //$historyState.logSink(id: "historyState")
        //    .store(in: &cancellables)
        #endif

        self.$dealState
            //.receive(on: DispatchQueue.main)
            .compactMap { viewState -> CurrentDeal? in
                guard case .result(let deal) = viewState, let currentDeal = CurrentDeal(deal: deal) else {
                    return nil
                }
                log.debug("1️⃣ CurrentDeal: \(currentDeal)")
                return currentDeal
            }
            .removeDuplicates()
            .flatMap { currentDeal in
                self.currentDealManager.save(currentDeal: currentDeal)
                    .catch { error -> Empty<Void, Never> in
                        log.error("1️⃣ Error saving current deal: \(error)")
                        return Empty<Void, Never>(completeImmediately: false)
                    }
            }
            .filter { [weak self] _ in self?.shouldRefreshWidget ?? false }
            .sink { [weak self] _ in
                // NOTE: this is currently run on a background thread
                log.debug("2️⃣ Have saved currentDeal")

                guard let strongSelf = self else { return }
                if #available(iOS 14, *) {
                    if strongSelf.shouldRefreshWidget {
                        log.debug("3️⃣ Reloading widgets ...")
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
                strongSelf.shouldRefreshWidget = false
            }
            .store(in: &cancellables)

        dealFetchResultManager.actionPublisher
            .sink { [weak self] action in
                switch action {
                case .fetchHistory(let cachePolicy):
                    self?.getDealHistory(cachePolicy: cachePolicy)
                }
            }
            .store(in: &cancellables)

        // switch credentialsProvider.currentUserState {
        // case .unknown:
        // TODO: should we indicate that we are in the process of initializing?
        credentialsProvider.initialize()
            .then { [weak self] _ in
                self?.credentialsProviderIsInitialized = true
                if let refreshEvent = self?.refreshEventQueue.pop() {
                    self?.refreshDeal(for: refreshEvent)
                }
            }.catch { [weak self] error in
                log.error("Unable to initialize credentialsProvider: \(error)")
                self?.dealState = .error(error)
            }
        // case .guest:
        //     credentialsProviderIsInitialized = true
        //     if let refreshEvent = refreshEventQueue.pop() {
        //         refreshDeal(for: refreshEvent)
        //     }
        // case .signedIn:
        //     log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        // case .signedOut:
        //     log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        // case .signedOutFederatedTokensInvalid:
        //     log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        // case .signedOutUserPoolsTokenInvalid:
        //     log.debug("currentUserState: \(credentialsProvider.currentUserState)")
        // }
    }

    // MARK: - CurrentDealWatcher Config

    // TODO: make throwing
    private func configureWatcher(cachePolicy: CachePolicy) {
        log.info("\(#function) - \(cachePolicy)")
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
            // swiftlint:disable:next line_length
            currentDealWatcher = try client.watchCurrentDeal(cachePolicy: cachePolicy, queue: .main) { [unowned self] result in
                switch result {
                case .success(let envelope):
                    guard let deal = envelope.data else {
                        log.error("Query failed to return result.")
                        self.dealState = .empty
                        return
                    }
                    //log.verbose("Deal: \(deal)")

                    self.refreshManager.update(.responseEnvelope(envelope))

                    // Don't call `callObservations(with:)` in `currentDeal` setter if no changes
                    // TODO: should this just be handled in the setter itself?
                    if case .result(let oldDeal) = self.dealState, oldDeal == deal {
                        log.verbose("\(#function) - No change, bailing: OLD: \(oldDeal) - NEW: \(deal)")
                        // TODO: `self.shouldRefreshWidget = false`?
                        return
                    }
                    self.shouldRefreshWidget = true
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

    /// Update current Deal in response to application event. Observers added through `addDealObserver(_:closure:)` will
    /// be notified of the result.
    /// - Parameter for: The application event to which the provider should respond.
    func refreshDeal(for event: RefreshEvent) {
        log.info("\(#function) - \(event)")

        guard credentialsProviderIsInitialized else {
            log.verbose("AWSMobileClient not initialized - deferring RefreshEvent: \(event)")
            refreshEventQueue.push(event)
            return
        }

        // TODO: peform fetch with .returnCacheDataAndFetch if dealState is .error?
        switch event {
        case .manual:
            guard currentDealWatcher != nil else {
                log.error("\(#function) - \(event) - currentDealWatcher not configured)")
                refreshDeal(for: .launch)
                return
            }
            refetchCurrentDeal(showLoading: true)
        // App State
        case .launch:
            let cachePolicy = refreshManager.cacheCondition.cachePolicy
            dealFetchResultManager.push(.fetchHistory(cachePolicy))

            // TODO: should we refresh widget?
            configureWatcher(cachePolicy: cachePolicy)
        case .launchFromNotification(let notification):
            // TODO: should we first check `UIApplication.shared.backgroundRefreshStatus`?

            // On iOS 13, it seemed that `AppDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`
            // was not being called when app was launched for a background notification, so we will start a
            // backgroundTask to ensure sufficient time to update deal in respnose. This seems to have been fixed on
            // iOS 14.

            // NOTE: this method requests the task assertion asynchronously; it is possible that the system could
            // suspend the app before that assertion is granted, though I have not seen any evidence of that happening.
            backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "NotificationBackgroundTask") {
                self.endTask()
            }

            switch notification {
            case .new:
                shouldRefreshWidget = true
            case .delta(let dealDelta):
                if case .launchStatus = dealDelta.deltaType {
                    shouldRefreshWidget = true
                }
            }

            // TODO: improve handling
            // - `DealNotification.new`: should we (a) configure watcher after fetching deal or (b) skip altogether?
            // - `DealNotification.delta`: should we try configuring watcher with `.returnCacheDataDontFetch` and then
            // try to apply the `DealDelta`, falling back to calling `client.fetchCurrentDeal(cachePolicy:queue:)` if
            // `dealID`s don't match?
            // TODO: configure watcher in closure for .fetchCurrentDeal?
            configureWatcher(cachePolicy: .returnCacheDataDontFetch)  // or use .returnCacheDataElseFetch?

            // TODO: **if case .new = dealNotification, call fetchDealInBackground() { _ in ... self.endTask() }
            currentDealOperation = client.fetchCurrentDeal(cachePolicy: .fetchIgnoringCacheData, queue: .main) { result in
                switch result {
                case .success(let envelope):
                    self.shouldRefreshWidget = true
                    self.refreshManager.update(.responseEnvelope(envelope))
                    self.dealState = envelope.data != nil ? .result(envelope.data!) : .empty
                case .failure(let error):
                    self.shouldRefreshWidget = false
                    log.error("\(error)")
                    self.dealState = .error(error)
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

            // TODO: show .loading if dealState is .empty / .error; otherwise use cacheCondition.loading
            let cacheCondition = refreshManager.cacheCondition
            refetchCurrentDeal(showLoading: cacheCondition.showLoading)

        // Notifications
        case .foregroundNotification(_, let completionHandler):
            // TODO: check case of `DealNotification` and just use DealDelta.apply(to:) for DealNotification.delta

            let presentationOptions: UNNotificationPresentationOptions
            if #available(iOS 14.0, *) {
                presentationOptions = [.list, .sound] // Use .list or .banner?
            } else {
                presentationOptions = [.alert, .sound]
            }

            guard currentDealWatcher != nil else {  // This really shouldn't be possible
                log.error("\(#function) - \(event) - currentDealWatcher not configured)")
                refreshDeal(for: .launch)
                completionHandler(presentationOptions)
                return
            }

            shouldRefreshWidget = true

            // TODO: still refresh if backgroundRefreshStatus == .available?
            refetchCurrentDeal(showLoading: true)

            completionHandler(presentationOptions)
        case .silentNotification(let notification, let completionHandler):
            switch notification {
            case .new(let dealID):
                fetchDealInBackground(dealID: dealID, fetchCompletionHandler: completionHandler)
            case .delta(let dealDelta):
                updateDealInBackground(dealDelta, fetchCompletionHandler: completionHandler)
            }
        }
    }

    // MARK: - Update

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

    typealias FetchCompletionHandler = (UIBackgroundFetchResult) -> Void

    /// Update current Deal in response to background notification carrying deal update.
    /// - Parameters:
    ///   - dealDelta: `DealDelta` representing the update carried by the notification.
    ///   - completionHandler: The block to execute when the download operation is complete.
    private func updateDealInBackground(_ dealDelta: DealDelta,
                                        fetchCompletionHandler completionHandler: @escaping FetchCompletionHandler
    ) {
        log.info("\(#function) - \(dealDelta)")
        if case .launchStatus = dealDelta.deltaType {
            shouldRefreshWidget = true
        }

        switch dealState {
        case .loading:
            log.info("\(#function) - already fetching Deal; pushing to dealFetchResultManager")
            dealFetchResultManager.push(.silentNotification(dealID: dealDelta.dealID, handler: completionHandler))

        case .result(let currentDeal):
            // FIXME: we currently rely on `MehSyncClient.updateCache(for:dealDelta:)` to compare dealIDs and return
            // error if they don't match; we should instead handle that here or in `refreshDeal(for:)`
            do {
                guard let updatedDeal = try dealDelta.apply(to: currentDeal) else {
                    log.info("No changes from applying \(dealDelta) to \(currentDeal)")
                    shouldRefreshWidget = false
                    completionHandler(.noData)
                    return
                }

                client.updateCache(for: updatedDeal, dealDelta: dealDelta)
                    .then({ _ in
                        log.verbose("Updated cache")
                        // TODO: update `lastDealResponse`?
                        //refreshManager?.update(.response(updatedDeal))
                        completionHandler(.newData)
                    }).catch({ [weak self] error in
                        log.error("Unable to update cache: \(error)")
                        self?.shouldRefreshWidget = false
                        completionHandler(.failed)
                    })
            } catch {
                log.error("Error applying \(dealDelta) to \(currentDeal): \(error); calling refreshDealInBackground()")
                fetchDealInBackground(dealID: dealDelta.dealID, fetchCompletionHandler: completionHandler)
            }
        default:
            // TODO: refetch
            log.warning("Unable to apply \(dealDelta) to \(dealState); calling refreshDealInBackground()")
            fetchDealInBackground(dealID: dealDelta.dealID, fetchCompletionHandler: completionHandler)
        }
    }

    /// Fetch current Deal from server in response to background notification.
    /// - Parameters:
    ///   - dealID: Id of the new `Deal` expected as current deal.
    ///   - completionHandler: The block to execute when the download operation is complete.
    private func fetchDealInBackground(dealID: GraphQLID,
                                       fetchCompletionHandler completionHandler: @escaping FetchCompletionHandler
    ) {
        log.verbose("\(#function)")
        // TODO: should we start a timer to ensure that the completionHandler is called within the next 30 - cushion seconds?

        shouldRefreshWidget = true

        // TEMP:
        if backgroundTask != .invalid {
            log.warning("\(#function) - backgroundTask appears to be in progress")
        }

        if !credentialsProviderIsInitialized {
            log.error("Trying to refresh Deal before initializing credentials provider")
            refreshEventQueue.push(.silentNotification(notification: .new(dealID), handler: completionHandler))
            return
        }

        // FIXME: this does not necessarily ensure we are not already fetching the current deal, since we may have
        // called `refreshDeal(showLoading: false, cachePolicy:)`
        guard dealState != ViewState<Deal>.loading else {
            log.info("\(#function) - already fetching Deal; pushing to dealFetchResultManager")
            dealFetchResultManager.push(.silentNotification(dealID: dealID, handler: completionHandler))
            return
        }

        refreshManager.update(.request)

        // TODO: set dealState to .loading if it's currently .empty / .error?
        currentDealOperation = client.fetchCurrentDeal(cachePolicy: .fetchIgnoringCacheData, queue: .main) { result in
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
                // FIXME: widget should reflect this error state, which suggests the current deal is outdated
                self.shouldRefreshWidget = false
                //self.dealState = .error(error)
                completionHandler(.failed)
            }
        }
    }

    private func endTask() {
        log.debug("Cancelling background tasks ...")
        currentDealOperation?.cancel() // TODO: do we need any logic to skip if fetch already completed?
        // TODO: check if case .dealState = .loading { // would this ever be the case?
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
}

// MARK: - Get
extension DataProvider {

    /// Return `Deal` from server.
    /// - Parameter id: The `id` of the `Deal` to fetch.
    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal> {
        // This should't be used to fetch the currentDeal and performing this check introduces coupling with
        // `MehSyncClient`
        let cachePolicy: CachePolicy = id == MehSyncClient.Constants.currentDealID ?
            .fetchIgnoringCacheData : .returnCacheDataElseFetch
        return client.fetchDeal(withID: id, cachePolicy: cachePolicy)
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

    /// Fetch recent Deals from server. Observers added through `addHistoryObserver(_:closure:)` will be notified of
    /// result.
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
