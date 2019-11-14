//
//  DataProviderType.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise

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
