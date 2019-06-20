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
    func getCurrentDeal()
    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal>
    func getDealHistory(from: Date, to: Date)
    // Refresh
    func refreshDeal(showLoading: Bool)
    func refreshDealInBackground(fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    // Observers
    func addDealObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<Deal>) -> Void) -> ObservationToken
    func addHistoryObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<[DealHistory]>) -> Void) -> ObservationToken
}

// MARK: - Implementation

class DataProvider: DataProviderType {
    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    // TODO: initialize with UserDefaultsManager; use AppGroup
    var lastDealUpdate: Date {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKey.lastDealUpdate.rawValue) as? Date ?? Date.distantPast
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.lastDealUpdate.rawValue)
        }
    }

    private let minimumRefreshInterval: TimeInterval = 60

    // TODO: rename `ViewState<T>` as `ResourceState<T>`?
    private var dealState: ViewState<Deal> {
        didSet {
            // TODO: check that viewState != oldValue before calling completions?
            callObservations(with: dealState)
        }
    }

    private var historyState: ViewState<[DealHistory]> {
        didSet {
            callObservations(with: historyState)
        }
    }

    private let appSyncClient: AWSAppSyncClient
    private var dealObservations: [UUID: (ViewState<Deal>) -> Void] = [:]
    private var historyObservations: [UUID: (ViewState<[DealHistory]>) -> Void] = [:]

    // MARK: - Lifecycle

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
            //dp.getDealHistory()
        }
    }

    // MARK: - Get

    func getCurrentDeal() {
        guard dealState != ViewState<Deal>.loading else { return }
        dealState = .loading
        let query = GetDealQuery(id: "current_deal")
        appSyncClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
            .then({ result in
                guard let deal = Deal(result.getDeal) else {
                    throw SyncClientError.myError(message: "Missing result")
                }
                self.lastDealUpdate = Date()
                self.dealState = .result(deal)
            }).catch({ error in
                log.error("\(#function): \(error.localizedDescription)")
                self.dealState = .error(error)
            })
    }

    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal> {
        let query = GetDealQuery(id: id)
        return appSyncClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
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

    /// Convenience method
    private func getDealHistory() {
        // TODO: account for TimeZones; do so at level of Calendar or DateFormatter?
        let today = Date()
        // TODO: move startDate / endDate to class properties?
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        getDealHistory(from: startDate, to: endDate, showLoading: false, cachePolicy: .fetchIgnoringCacheData)
    }

    private func getDealHistory(from startDate: Date, to endDate: Date, showLoading: Bool, cachePolicy: CachePolicy) {
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
                self?.historyState = .result(items.reversed().compactMap { $0 })
            }.catch { error in
                log.error("\(#function): \(error.localizedDescription)")
                // TODO: still show .error if !showLoading?
                //if showLoading {
                self.historyState = .error(error)
                //}
            }
    }

    // MARK: - Refresh

    func refreshDeal(showLoading: Bool = false) {
        log.debug("\(#function)")
        guard dealState != ViewState<Deal>.loading else {
            log.debug("\(#function) - already loading; will bail")
            return
        }

        var cachePolicy: CachePolicy
        if abs(lastDealUpdate.timeIntervalSinceNow) < minimumRefreshInterval {
            // Always fetch results from the server.
            cachePolicy = .fetchIgnoringCacheData
        } else {
            // Return data from the cache if available, and always fetch results from the server.
            cachePolicy = .returnCacheDataAndFetch
        }

        if showLoading {
            dealState = .loading
        }

        // TODO: use Constants for currentDealID
        let query = GetDealQuery(id: "current_deal")
        appSyncClient.fetch(query: query, cachePolicy: cachePolicy)
            .then({ result in
                guard let deal = Deal(result.getDeal) else {
                    throw SyncClientError.myError(message: "Missing result")
                }
                self.lastDealUpdate = Date()
                if case .result(let oldDeal) = self.dealState {
                    if oldDeal != deal {
                        self.dealState = .result(deal)
                    }
                } else {
                    self.dealState = .result(deal)
                }
            }).catch({ error in
                log.error("\(#function): \(error.localizedDescription)")
                //if showOtherViewStates {
                //self.dealState = .error(error)
                //}
            })
    }

    func refreshDealInBackground(fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        log.debug("\(#function)")
        guard dealState != ViewState<Deal>.loading else {
            log.debug("Already fetching Deal; bailing from refreshDealInBackground")
            return
        }
        let query = GetDealQuery(id: "current_deal")
        appSyncClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
            .then({ result in
                guard let newDeal = Deal(result.getDeal) else {
                    throw SyncClientError.myError(message: "Missing result")
                }
                self.lastDealUpdate = Date()
                if case .result(let oldDeal) = self.dealState {
                    if oldDeal != newDeal {
                        log.info("BACKGROUND_APP_REFRESH: newData")
                        self.dealState = .result(newDeal)
                        completionHandler(.newData)
                    } else {
                        log.info("BACKGROUND_APP_REFRESH: noData")
                        completionHandler(.noData)
                    }
                } else {
                    log.info("BACKGROUND_APP_REFRESH: newData")
                    self.dealState = .result(newDeal)
                    completionHandler(.newData)
                }
            }).catch({ error in
                log.error("\(#function): \(error.localizedDescription)")
                //self.dealState = .error(error)
                completionHandler(.failed)
            })
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
