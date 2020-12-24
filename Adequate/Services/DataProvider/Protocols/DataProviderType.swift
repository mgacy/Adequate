//
//  DataProviderType.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise // avoid name collision with AWSAppSync.Promise

protocol DataProviderType {
    typealias DealHistory = DealHistoryQuery.Data.DealHistory.Item

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

    // MARK: Observers

    /// Add observer to be notified of changes to current Deal.
    /// - Parameters:
    ///   - : The observer.
    ///   - closure: Closure to execute on changes to current Deal.
    func addDealObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<Deal>) -> Void) -> ObservationToken

    /// Add observer to be notified of changes to Deal history.
    /// - Parameters:
    ///   - : The observer.
    ///   - closure: Closure to execute on changes to Deal history.
    func addHistoryObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<[DealHistory]>) -> Void) -> ObservationToken
}
