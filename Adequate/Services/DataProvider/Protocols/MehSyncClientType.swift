//
//  MehSyncClientType.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise

protocol MehSyncClientType {

    // MARK: - Result Handler

    typealias DealResultHandler = OperationResultHandler<Deal?>

    func watchCurrentDeal(cachePolicy: CachePolicy,
                          queue: DispatchQueue,
                          resultHandler: @escaping DealResultHandler) throws -> GraphQLQueryWatcher<GetDealQuery>

    func fetchCurrentDeal(cachePolicy: CachePolicy,
                          queue: DispatchQueue,
                          resultHandler: @escaping DealResultHandler) -> Cancellable

    // MARK: - Promise

    func fetchDeal(withID id: GraphQLID, cachePolicy: CachePolicy) -> Promise<GetDealQuery.Data>

    func fetchDealHistory(limit: Int, nextToken: String?, cachePolicy: CachePolicy) -> Promise<DealHistoryQuery.Data>

    func updateCache(for deal: Deal, dealDelta: DealDelta) -> Promise<Void>
}
