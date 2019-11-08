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
    func fetchCurrentDeal(cachePolicy: CachePolicy) -> Promise<GetDealQuery.Data>
    func fetchDeal(withID id: GraphQLID, cachePolicy: CachePolicy) -> Promise<GetDealQuery.Data>
    func fetchDealHistory(from startDate: Date, to endDate: Date, cachePolicy: CachePolicy) -> Promise<ListDealsForPeriodQuery.Data>
    func updateCache(for deal: Deal, delta: DealDelta) throws
}
