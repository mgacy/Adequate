//
//  DataProviderMock.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise
@testable import Adequate

class DataProviderMock: DataProviderType {
    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    var dealState: ViewState<Deal> {
        didSet {
            callObservations(with: dealState)
        }
    }

    var historyState: ViewState<[DealHistory]> {
        didSet {
            callObservations(with: historyState)
        }
    }

    private var dealObservations: [UUID: (ViewState<Deal>) -> Void] = [:]
    private var historyObservations: [UUID: (ViewState<[DealHistory]>) -> Void] = [:]

    // MARK: - Lifecycle

    init() {
        self.dealState = .empty
        self.historyState = .empty
    }

    init(error: Error) {
        self.dealState = .error(error)
        self.historyState = .error(error)
    }

    // MARK: - Get

    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal> {
        return Promise(error: SyncClientError.myError(message: "Missing AWSAppSyncClient"))
    }

    func getDealHistory(from: Date, to: Date) {}

    // MARK: - Refresh

    func refreshDeal(for: RefreshEvent) {}

    // MARK: - Update

    func updateDealInBackground(_: DealDelta, fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        fetchCompletionHandler(.failed)
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
