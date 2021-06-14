//
//  DataProviderMock.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise // avoid name collision with AWSAppSync.Promise
@testable import Adequate

class DataProviderMock: DataProviderType {
    typealias DealHistory = DealHistoryQuery.Data.DealHistory.Item

    @Published var dealState: ViewState<Deal> = .empty
    var dealPublisher: Published<ViewState<Deal>>.Publisher { $dealState }

    @Published var historyState: ViewState<[DealHistory]> = .empty
    var historyPublisher: Published<ViewState<[DealHistory]>>.Publisher { $historyState }

    /// Response that will be returned from `getDeal(withID:)`
    var dealResponse: Result<GetDealQuery.Data.GetDeal>!

    /// Completion handler passed to `updateDealInBackground(_:fetchCompletionHandler:)`
    var backgroundUpdateHandler: ((UIBackgroundFetchResult) -> Void)?

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
        switch dealResponse {
        case .success(let deal):
            return Promise(value: deal)
        case .failure(let error):
            return Promise(error: error)
        case .none:
            return Promise(error: SyncClientError.missingClient)
        }
    }

    func getDealHistory() {}

    // MARK: - Refresh

    func refreshDeal(for: RefreshEvent) {}

    // MARK: - Update

    func updateDealInBackground(_: DealNotification, fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // TODO: check and notify if we are replacing existing handler?
        backgroundUpdateHandler = fetchCompletionHandler
        fetchCompletionHandler(.failed)
    }
}
