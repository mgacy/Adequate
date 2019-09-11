//
//  DataProvider.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/28/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise

// MARK: - Protocol

protocol DataProviderType {
    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod
    // Get
    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal>
    func getDealHistory(from: Date, to: Date)
    // Refresh
    func refreshDeal(for: RefreshEvent)
    // Update
    func updateDealInBackground(_: DealDelta, fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    // Observers
    func addDealObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<Deal>) -> Void) -> ObservationToken
    func addHistoryObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<[DealHistory]>) -> Void) -> ObservationToken
}

// MARK: - Implementation

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

    private let appSyncClient: AWSAppSyncClient
    private var dealObservations: [UUID: (ViewState<Deal>) -> Void] = [:]
    private var historyObservations: [UUID: (ViewState<[DealHistory]>) -> Void] = [:]
    // TODO: use a task queue for RefreshEvents / fetches?

    private var fetchCompletionObserver: CompletionWrapper<UIBackgroundFetchResult>?
    private var refreshHistoryObserver: CompletionWrapper<Void>?

    // MARK: - Lifecycle

    convenience init(appSyncConfig: AWSAppSyncClientConfiguration) throws {
        let appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        appSyncClient.apolloClient?.cacheKeyForObject = { $0["id"] }
        self.init(appSync: appSyncClient)
    }

    init(appSync: AWSAppSyncClient) {
        self.appSyncClient = appSync
        self.dealState = .empty
        self.historyState = .empty

        addDealObserver(self) { dp, viewState in
            guard case .result(let deal) = viewState, let currentDeal = CurrentDeal(deal: deal) else {
                return
            }
            let currentDealManager = CurrentDealManager()
            currentDealManager.saveDeal(currentDeal)
        }
    }

    // MARK: - Get

    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal> {
        // TODO: if id != 'current_deal', we should be able to use `.returnCacheDataElseFetch`
        return getDeal(withID: id, cachePolicy: .fetchIgnoringCacheData)
    }

    private func getDeal(withID id: GraphQLID, cachePolicy: CachePolicy = .fetchIgnoringCacheData) -> Promise<GetDealQuery.Data.GetDeal> {
        let query = GetDealQuery(id: id)
        return appSyncClient.fetch(query: query, cachePolicy: cachePolicy)
            .then({ result -> GetDealQuery.Data.GetDeal in
                guard let deal = result.getDeal else {
                    throw SyncClientError.myError(message: "Missing result")
                }
                return deal
            }).recover({ error in
                log.error("\(#function): \(error.localizedDescription)")
                throw error
            })
    }

    func getDealHistory(from startDate: Date, to endDate: Date) {
        // FIXME: decide on CachePolicy: .fetchIgnoringCacheData / .returnCacheDataAndFetch
        getDealHistory(from: startDate, to: endDate, showLoading: true, cachePolicy: .returnCacheDataAndFetch)
    }

    private func getDealHistory(from startDate: Date, to endDate: Date, showLoading: Bool, cachePolicy: CachePolicy) {
        log.debug("\(#function) - \(startDate) - \(endDate) - \(cachePolicy)")
        //guard historyState != ViewState<[DealHistory]>.loading else { return }
        if showLoading {
            historyState = .loading
        }

        let startDateString = DateFormatter.yyyyMMddEST.string(from: startDate)
        let endDateString = DateFormatter.yyyyMMddEST.string(from: endDate)
        let query = ListDealsForPeriodQuery(startDate: startDateString, endDate: endDateString)
        // TODO: replace with `appSyncClient.watch(query:, cachePolicy:, queue:, resultHandler:)`
        appSyncClient.fetch(query: query, cachePolicy: cachePolicy)
            .then { [weak self] result in
                guard let items = result.listDealsForPeriod else {
                    throw SyncClientError.myError(message: "Missing result")
                }
                if items.isEmpty {
                    self?.historyState = .empty
                } else {
                    self?.historyState = .result(items.reversed().compactMap { $0 })
                }
            }.catch { error in
                log.error("\(#function): \(error.localizedDescription)")
                // TODO: still show .error if !showLoading?
                //if showLoading {
                self.historyState = .error(error)
                //}
            }
    }

    // MARK: - Refresh

    func refreshDeal(for event: RefreshEvent) {
        log.verbose("\(#function) - \(event)")
        switch event {
        case .manual:
            refreshDeal(showLoading: true, cachePolicy: .fetchIgnoringCacheData)
        // App State
        case .launch:
            var cachePolicy: CachePolicy = .fetchIgnoringCacheData

            // Can we rely on the cache?
            if case .available = UIApplication.shared.backgroundRefreshStatus {
                if lastDealResponse.timeIntervalSince(lastDealRequest) >= 0 {
                    // Our last request succeeded
                    // TODO: verify that Date().timeIntervalSince(lastDealCreatedAt) < 24 hours
                    cachePolicy = .returnCacheDataAndFetch // or .returnCacheDataElseFetch?
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
            refreshHistoryObserver = makeRefreshHistoryObserver(showLoading: true, cachePolicy: .fetchIgnoringCacheData)

            refreshDeal(showLoading: true, cachePolicy: cachePolicy)
        case .launchFromNotification:
            // TODO: improve handling
            refreshDeal(showLoading: true, cachePolicy: .fetchIgnoringCacheData)
        case .foreground:
            // TODO: showLoading and fetch if Date().timeIntervalSince(lastDealCreatedAt) >= 24 hours
            // TODO: send notification to PagedImageViewDataSource to reload any views with .error ViewState?
            if case .available = UIApplication.shared.backgroundRefreshStatus {
                if lastDealResponse.timeIntervalSince(lastDealRequest) < 0 {
                    // Last request failed
                    refreshDeal(showLoading: false, cachePolicy: .fetchIgnoringCacheData)
                } else {
                    log.debug("Skipping refresh")
                    return
                }
            } else {
                log.debug("backgroundRefreshStatus: \(UIApplication.shared.backgroundRefreshStatus)")
                refreshDeal(showLoading: false, cachePolicy: .fetchIgnoringCacheData)
            }
        // Notifications
        case .foregroundNotification:
            // TODO: still refresh if backgroundRefreshStatus == .available?
            refreshDeal(showLoading: true, cachePolicy: .fetchIgnoringCacheData)
        case .silentNotification(let completionHandler):
            refreshDealInBackground(fetchCompletionHandler: completionHandler)
        }
    }

    private func refreshDeal(showLoading: Bool, cachePolicy: CachePolicy) {
        log.verbose("\(#function) - \(showLoading) - \(cachePolicy)")
        guard dealState != ViewState<Deal>.loading else {
            // FIXME: what if cachePolicy differs from that of current request?
            log.debug("Already loading Deal; will bail")
            return
        }

        if showLoading {
            dealState = .loading
        }

        // TODO: use Constants for currentDealID
        let query = GetDealQuery(id: "current_deal")
        // TODO: specify queue?
        appSyncClient.fetch(query: query, cachePolicy: cachePolicy)
            .then({ result in
                guard let deal = Deal(result.getDeal) else {
                    throw SyncClientError.myError(message: "Missing result")
                }
                // TODO: don't set .lastDealResponse if cachePolicy == .returnCacheDataDontFetch / returnCacheDataElseFetch?
                self.lastDealResponse = Date()
                //self.lastDealCreatedAt = DateFormatter.iso8601Full.date(from: deal.createdAt)
                if case .result(let oldDeal) = self.dealState {
                    if oldDeal != deal {
                        self.dealState = .result(deal)
                    }
                } else {
                    self.dealState = .result(deal)
                }
            }).catch({ error in
                log.error("\(#function): \(error.localizedDescription)")
                // TODO: is this check sufficient to cover desired behavior?
                if showLoading {
                    self.dealState = .error(error)
                }
            })
    }

    private func refreshDealInBackground(fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        log.verbose("\(#function)")
        self.lastDealRequest = Date()
        guard dealState != ViewState<Deal>.loading else {
            log.debug("Already fetching Deal; setting .fetchCompletionObserver")
            if fetchCompletionObserver != nil {
                log.error("Replacing existing .fetchCompletionObserver")
            }
            fetchCompletionObserver = makeBackgroundFetchObserver(completionHandler: completionHandler)
            return
        }
        let query = GetDealQuery(id: "current_deal")
        appSyncClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
            .then({ result in
                guard let newDeal = Deal(result.getDeal) else {
                    throw SyncClientError.myError(message: "Missing result")
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
        guard case .result(let currentDeal) = dealState else {
            log.info("\(#function) - already fetching Deal; setting .wrappedHandler")
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
                // TODO: update cache
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
                    // TODO: update cache
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
                log.debug("BACKGROUND_APP_REFRESH: newData")
                wrapper.complete(with: .newData)
            case .error:
                log.debug("BACKGROUND_APP_REFRESH: failed")
                wrapper.complete(with: .failed)
            case .empty:
                log.debug("BACKGROUND_APP_REFRESH: noData")
                wrapper.complete(with: .noData)
            case .loading:
                // This is called immediately; ignore it
                break
            }
        }
        return observer
    }

    private func makeRefreshHistoryObserver(showLoading: Bool, cachePolicy: CachePolicy) -> CompletionWrapper<Void> {
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
                self?.getDealHistory(from: startDate, to: endDate, showLoading: showLoading, cachePolicy: cachePolicy)
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
