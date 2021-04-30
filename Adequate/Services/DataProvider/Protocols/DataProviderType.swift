//
//  DataProviderType.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Combine
import AWSAppSync
import class Promise.Promise // avoid name collision with AWSAppSync.Promise

protocol DataProviderType {
    typealias DealHistory = DealHistoryQuery.Data.DealHistory.Item

    var dealState: ViewState<Deal> { get }

    var dealPublisher: Published<ViewState<Deal>>.Publisher { get }

    var historyState: ViewState<[DealHistory]> { get }

    var historyPublisher: Published<ViewState<[DealHistory]>>.Publisher { get }

    // MARK: Refresh

    /// Update current Deal in response to application event. Observers added through `addDealObserver(_:closure:)` will
    /// be notified of the result.
    /// - Parameter for: The application event to which the provider should respond.
    func refreshDeal(for: RefreshEvent)

    // MARK: Fetch

    /// Return `Deal` from server.
    /// - Parameter id: The `id` of the `Deal` to fetch.
    func getDeal(withID id: GraphQLID) -> Promise<GetDealQuery.Data.GetDeal>

    /// Fetch recent Deals from server. Observers added through `addHistoryObserver(_:closure:)` will be notified of
    /// result.
    func getDealHistory()
}
