//
//  DataProvider.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/28/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import AWSMobileClient
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise

class DataProvider: DataProviderType {
    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    // TODO: initialize with UserDefaultsManager; use AppGroup
    private let defaults: UserDefaults = .standard

    /// The last time we tried to fetch the current Deal (in response to Notification)
    var lastDealRequest: Date {
        get {
            return defaults.object(forKey: UserDefaultsKey.lastDealRequest.rawValue) as? Date ?? Date.distantPast
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.lastDealRequest.rawValue)
        }
    }

    /// The last time we succeeded in fetching the current Deal
    var lastDealResponse: Date {
        get {
            return defaults.object(forKey: UserDefaultsKey.lastDealResponse.rawValue) as? Date ?? Date.distantPast
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.lastDealResponse.rawValue)
        }
    }
    /*
    /// The .createdAt of last Deal fetched from server
    var lastDealCreatedAt: Date {
        get {
            return defaults.object(forKey: UserDefaultsKey.lastDealCreatedAt.rawValue) as? Date ?? Date.distantPast
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.lastDealCreatedAt.rawValue)
        }
    }
    */
    private let minimumRefreshInterval: TimeInterval = 60

    // TODO: rename `ViewState<T>` as `ResourceState<T>`?
    private var dealState: ViewState<Deal> {
        didSet {
            // TODO: check that viewState != oldValue before calling completions?

            if case .result(let deal) = dealState {
                log.verbose("New dealState: Result: Deal(title: \(deal.title), launchStatus: \(String(describing: deal.launchStatus)))")
            } else {
                log.verbose("New dealState: \(dealState)")
            }

            callObservations(with: dealState)
        }
    }

    private var historyState: ViewState<[DealHistory]> {
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
    private var credentialsProviderIsInitialized: Bool = false

    private let client: MehSyncClientType

    private var currentDealWatcher: GraphQLQueryWatcher<GetDealQuery>?

    private var dealObservations: [UUID: (ViewState<Deal>) -> Void] = [:]
    private var historyObservations: [UUID: (ViewState<[DealHistory]>) -> Void] = [:]

    private var fetchCompletionObserver: CompletionWrapper<UIBackgroundFetchResult>?
    private var refreshHistoryObserver: CompletionWrapper<Void>?

    // TODO: use a task queue (`OperationQueue`) for RefreshEvents / fetches? See `AWSPerformMutationQueue`
    private var pendingRefreshEvent: RefreshEvent?

    // MARK: - Lifecycle

    init(credentialsProvider: CredentialsProvider) {
        self.dealState = .empty
        self.historyState = .empty
        self.credentialsProvider = credentialsProvider
        self.client = MehSyncClient(credentialsProvider: credentialsProvider)

        addDealObserver(self) { dp, viewState in
            guard case .result(let deal) = viewState, let currentDeal = CurrentDeal(deal: deal) else {
                return
            }
            let currentDealManager = CurrentDealManager()
            currentDealManager.saveDeal(currentDeal)
        }

        // TODO: should we indicate that we are in the process of initializing?
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

        addDealObserver(self) { dp, viewState in
            guard case .result(let deal) = viewState, let currentDeal = CurrentDeal(deal: deal) else {
                return
            }
            let currentDealManager = CurrentDealManager()
            currentDealManager.saveDeal(currentDeal)
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

    // MARK: - CurrentDealWatcher

    /// Used by currentDealWatcher's resultHandler to determine whether to update .lastDealResponse.
    private var haveInitializedWatcher: Bool = false

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
            return
        }
        guard dealState == ViewState<Deal>.empty else {
            log.error(".dealState is not empty")
            return
        }

        if case .fetchIgnoringCacheData = cachePolicy {
            lastDealRequest = Date()
        }

        dealState = .loading
        do {
            currentDealWatcher = try client.watchCurrentDeal(cachePolicy: cachePolicy, queue: .main) { result in
                switch result {
                case .success(let deal):
                    //log.verbose("Deal: \(deal)")

                    // TODO: handle lastDealRequest?
                    if self.haveInitializedWatcher {
                        // We have already fetched a result that may have been from the cache; this is from the server.
                        self.lastDealResponse = Date()
                        //self.lastDealCreatedAt = DateFormatter.iso8601Full.date(from: deal.createdAt)
                    } else {
                        // This is the first time fetching
                        if case .fetchIgnoringCacheData = cachePolicy {
                            self.lastDealRequest = Date()
                            self.lastDealResponse = Date()
                        }
                    }

                    if case .result(let oldDeal) = self.dealState {
                        if oldDeal != deal {
                            self.dealState = .result(deal)
                        }
                    } else {
                        self.dealState = .result(deal)
                    }

                    self.haveInitializedWatcher = true
                case .failure(let error):
                    log.error("Error: \(error.localizedDescription)")

                    // TODO: should we really display an error here?
                    //if !self.haveInitializedWatcher {
                    self.dealState = .error(error)
                    //}
                    //self.haveInitializedWatcher = true // ?
                }
            }
        } catch {
            log.error("\(#function) - unable to watchCurrentDeal: \(error.localizedDescription)")
            self.dealState = .error(error)
        }
    }

    private func refetchCurrentDeal(showLoading: Bool) {
        // TODO: verify credentialsProvider.currentUserState?
        guard credentialsProviderIsInitialized else {
            log.error("\(#function) - credentialsProvider has not been initialized")
            // TODO: try to initialze credentialsProvider again?
            return
        }
        guard let currentDealWatcher = currentDealWatcher else {
            log.error("\(#function) - currentDealWatcher not configured")
            //dealState = .loading
            //currentDealWatcher = configureWatcher(cachePolicy: .fetchIgnoringCacheData)
            return
        }

        // TODO: how to handle different dealStates?
        log.verbose("\(#function) - \(showLoading) - \(dealState)")

        if showLoading {
            dealState = .loading
        }

        lastDealRequest = Date()
        currentDealWatcher.refetch()
    }

    // MARK: - Get

    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal> {
        // TODO: if id != Constants.currentDealID, we should be able to use `.returnCacheDataElseFetch`
        return client.fetchDeal(withID: id,cachePolicy: .fetchIgnoringCacheData)
            .then({ result -> GetDealQuery.Data.GetDeal in
                guard let deal = result.getDeal else {
                    throw SyncClientError.missingData(data: result)
                }
                return deal
            }).recover({ error in
                log.error("\(#function): \(error.localizedDescription)")
                throw error
            })
    }

    func getDealHistory(from startDate: Date, to endDate: Date) {
        // FIXME: decide on CachePolicy: .fetchIgnoringCacheData / .returnCacheDataAndFetch
        getDealHistory(from: startDate, to: endDate, cachePolicy: .returnCacheDataAndFetch)
    }

    private func getDealHistory(from startDate: Date, to endDate: Date, cachePolicy: CachePolicy) {
        // TODO: remove `showLoading` arg
        log.debug("\(#function) - \(startDate) - \(endDate) - \(cachePolicy)")
        //guard historyState != ViewState<[DealHistory]>.loading else { return }

        historyState = .loading
        client.fetchDealHistory(from: startDate, to: endDate, cachePolicy: cachePolicy)
            .then { [weak self] result in
                guard let items = result.listDealsForPeriod else {
                    throw SyncClientError.missingData(data: result)
                }
                if items.isEmpty {
                    self?.historyState = .empty
                } else {
                    self?.historyState = .result(items.reversed().compactMap { $0 })
                }
            }.catch { error in
                log.error("\(#function): \(error.localizedDescription)")
                // TODO: always show error?
                self.historyState = .error(error)
            }
    }

    // MARK: - Refresh

    func refreshDeal(for event: RefreshEvent) {
        log.verbose("\(#function) - \(event)")

        guard credentialsProviderIsInitialized else {
            if let currentPendingRefreshEvent = pendingRefreshEvent {
                log.warning("AWSMobileClient not initialized - deferring RefreshEvent: \(event) - replacing: \(currentPendingRefreshEvent)")
                // TODO: add logic to determine whether the new event should replace the current one
                pendingRefreshEvent = event
            } else {
                log.warning("AWSMobileClient not initialized - deferring RefreshEvent: \(event)")
                pendingRefreshEvent = event
            }
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
            var cachePolicy: CachePolicy = .fetchIgnoringCacheData

            // Can we rely on the cache?
            if case .available = UIApplication.shared.backgroundRefreshStatus {
                if lastDealResponse.timeIntervalSince(lastDealRequest) >= 0 {
                    // Our last request succeeded
                    // TODO: verify that Date().timeIntervalSince(lastDealCreatedAt) < 24 hours
                    cachePolicy = .returnCacheDataAndFetch
                } else {
                    // Our last request failed
                    cachePolicy = .fetchIgnoringCacheData
                }
            } else {
                log.debug("backgroundRefreshStatus: \(UIApplication.shared.backgroundRefreshStatus)")
                cachePolicy = .fetchIgnoringCacheData
            }

            // Update Deal history after fetching current Deal
            // TODO: use cachePolicy
            refreshHistoryObserver = makeRefreshHistoryObserver(cachePolicy: .fetchIgnoringCacheData)

            configureWatcher(cachePolicy: cachePolicy)
        case .launchFromNotification:
            // TODO: improve handling
            configureWatcher(cachePolicy: .fetchIgnoringCacheData)
        case .foreground:

            guard currentDealWatcher != nil else {
                log.error("\(#function) - \(event) - currentDealWatcher not configured)")
                refreshDeal(for: .launch)
                return
            }

            let showLoading: Bool
            // TODO: showLoading and fetch if Date().timeIntervalSince(lastDealCreatedAt) >= 24 hours
            if case .available = UIApplication.shared.backgroundRefreshStatus {
                if lastDealResponse.timeIntervalSince(lastDealRequest) < 0 {
                    // Last request failed
                    showLoading = true
                } else {
                    //log.debug("Skipping refresh")
                    //return
                    showLoading = false
                }
            } else {
                log.debug("backgroundRefreshStatus: \(UIApplication.shared.backgroundRefreshStatus)")
                showLoading = false // ?
            }

            refetchCurrentDeal(showLoading: showLoading)

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

    private func refreshDealInBackground(fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        log.verbose("\(#function)")
        if !credentialsProviderIsInitialized {
            log.error("Trying to refresh Deal before initializing credentials provider")
            // TODO: check if we are replacing existing pendingRefreshEvent
            pendingRefreshEvent = .silentNotification(completionHandler)
            return
        }

        self.lastDealRequest = Date()
        // FIXME: this does not necessarily ensure we are not already fetching the current deal, since we may have called `refreshDeal(showLoading: false, cachePolicy:)`
        guard dealState != ViewState<Deal>.loading else {
            log.debug("Already fetching Deal; setting .fetchCompletionObserver")
            if fetchCompletionObserver != nil {
                log.error("Replacing existing .fetchCompletionObserver")
            }
            fetchCompletionObserver = makeBackgroundFetchObserver(completionHandler: completionHandler)
            return
        }

        client.fetchCurrentDeal(cachePolicy: .fetchIgnoringCacheData)
            .then({ result in
                guard let newDeal = Deal(result.getDeal) else {
                    throw SyncClientError.missingData(data: result)
                }
                self.lastDealResponse = Date()
                //self.lastDealCreatedAt = DateFormatter.iso8601Full.date(from: deal.createdAt)
                if case .result(let oldDeal) = self.dealState {
                    if oldDeal != newDeal {
                        log.debug("BACKGROUND_APP_REFRESH: newData")
                        // TODO: start background task to download image
                        self.dealState = .result(newDeal)
                        completionHandler(.newData)
                    } else {
                        log.debug("BACKGROUND_APP_REFRESH: noData")
                        completionHandler(.noData)
                    }
                } else {
                    log.debug("BACKGROUND_APP_REFRESH: newData")
                    self.dealState = .result(newDeal)
                    completionHandler(.newData)
                }
            }).catch({ error in
                log.error("\(#function): \(error.localizedDescription)")
                //self.dealState = .error(error)
                completionHandler(.failed)
            })
    }

    // MARK: - Update

    func updateDealInBackground(_ delta: DealDelta, fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        log.verbose("\(#function) - \(delta)")
        // FIXME: this prevents fetch if there was an error last time
        guard case .result(let currentDeal) = dealState else {
            // TODO: for `launchStatus` and `commentCount`, verify that the delta applies to currentDeal
            // TODO: try to fetch from cache and see if that is the correct one?
            log.info("\(#function) - already fetching Deal; setting .fetchCompletionObserver")
            if fetchCompletionObserver != nil {
                log.error("Replacing existing .fetchCompletionObserver")
            }
            fetchCompletionObserver = makeBackgroundFetchObserver(completionHandler: completionHandler)
            return
        }

        switch delta {
        case .newDeal:
            refreshDealInBackground(fetchCompletionHandler: completionHandler)
        case .launchStatus(let newStatus):
            if currentDeal.launchStatus != newStatus {
                let launchStatusLens = Deal.lens.launchStatus
                let updatedDeal = launchStatusLens.set(newStatus)(currentDeal)
                dealState = .result(updatedDeal)

//                do {
//                    try client.updateCache(for: updatedDeal, delta: delta)
//                    // TODO: update `lastDealResponse`?
//                    completionHandler(.newData)
//                } catch {
//                    log.error("Unable to update cache")
//                    completionHandler(.failed)
//                }

                // TODO: handle error?
                try? client.updateCache(for: updatedDeal, delta: delta)
                // TODO: update `lastDealResponse`?
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        case .commentCount(let newCount):
            if let currentTopic = currentDeal.topic {
                if currentTopic.commentCount != newCount {
                    let dealAffine = Deal.lens.topic.toAffine()
                    let topicPrism = Optional<Topic>.prism.toAffine()
                    let topicAffine = Topic.lens.commentCount.toAffine()
                    let composed = dealAffine.then(topicPrism).then(topicAffine)

                    guard let updatedDeal = composed.trySet(newCount)(currentDeal) else {
                        fatalError("Problem with Affine composition for Deal.topic.commentCount")
                    }
                    dealState = .result(updatedDeal)

                    // TODO: handle error?
                    try? client.updateCache(for: updatedDeal, delta: delta)
                    // TODO: update `lastDealResponse`?
                    completionHandler(.newData)
                } else {
                    completionHandler(.noData)
                }
            } else {
                refreshDealInBackground(fetchCompletionHandler: completionHandler)
            }
        }
    }

    // MARK: - Observers

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

    func addHistoryObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, ViewState<[DealHistory]>) -> Void) -> ObservationToken {
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

    private func callObservations(with dealState: ViewState<[DealHistory]>) {
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
                // TODO: account for TimeZones; do so at level of Calendar or DateFormatter?
                let today = Date()
                // TODO: move startDate / endDate to class properties?
                let startDate = Calendar.current.date(byAdding: .month, value: -1, to: today)!
                let endDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
                self?.getDealHistory(from: startDate, to: endDate, cachePolicy: cachePolicy)
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

// MARK: - Constants
extension DataProvider {
    private enum Constants {
        static var cacheKey: String { return "id" }
    }
}
