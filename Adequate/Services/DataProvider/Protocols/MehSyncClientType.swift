//
//  MehSyncClientType.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise

protocol MehSyncClientType {
    // Specify `Swift.Result` to avoid interference with `AWSAppSync.Result`
    typealias DealResultHandler = (Swift.Result<Deal?, SyncClientError>) -> Void

    func fetchCurrentDeal(cachePolicy: CachePolicy, queue: DispatchQueue, resultHandler: @escaping DealResultHandler) -> Cancellable
    func fetchDeal(withID id: GraphQLID, cachePolicy: CachePolicy) -> Promise<GetDealQuery.Data>
    func fetchDealHistory(from startDate: Date, to endDate: Date, cachePolicy: CachePolicy) -> Promise<ListDealsForPeriodQuery.Data>
    func watchCurrentDeal(cachePolicy: CachePolicy, queue: DispatchQueue, resultHandler: @escaping DealResultHandler) throws -> GraphQLQueryWatcher<GetDealQuery>
    func updateCache(for deal: Deal, delta: DealDelta) -> Promise<Void>
}
