//
//  AWSAppSyncClient+Promise.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise

extension AWSAppSyncClient {

    // public typealias OperationResultHandler<Operation: GraphQLOperation> = (_ result: GraphQLResult<Operation.Data>?, _ error: Error?) -> Void
    // resultHandler: ((GraphQLResult<GraphQLSelectionSet>?, Error?) -> Void)

    /// Fetches a query from the server or from the local cache, depending on the current contents of the cache and the specified cache policy.
    ///
    /// - Parameters:
    ///   - query: The query to fetch.
    ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server and when data should be loaded from the local cache.
    ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
    /// - Returns: A Promise.
    public func fetch<Query: GraphQLQuery>(query: Query, cachePolicy: CachePolicy = .returnCacheDataElseFetch, queue: DispatchQueue = DispatchQueue.main) -> Promise<Query.Data> {
        return Promise<Query.Data> { fulfill, reject in
            self.fetch(query: query, cachePolicy: cachePolicy, queue: queue) { result, error in
                if let error = error {
                    // TODO: should I wrap in SyncClientError here or higher up?
                    reject(SyncClientError.network(error: error))
                } else if let result = result, let data = result.data {
                    fulfill(data)
                } else {
                    // FIXME: handle case where there is no data; a query for which there is no result
                    fatalError("Something has gone horribly wrong.")
                }
            }
        }
    }

    /// Performs a mutation by sending it to the server.
    ///
    /// - Parameters:
    ///   - mutation: The mutation to perform.
    ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
    /// - Returns: A Promise.
    public func perform<Mutation: GraphQLMutation>(mutation: Mutation, queue: DispatchQueue = DispatchQueue.main) -> Promise<Mutation.Data> {
        return Promise<Mutation.Data> { fulfill, reject in
            self.perform(mutation: mutation, queue: queue, optimisticUpdate: nil, conflictResolutionBlock: nil) { result, error in
                if let error = error {
                    reject(SyncClientError.network(error: error))
                } else if let result = result {
                    if let errors = result.errors {
                        reject(SyncClientError.graphQL(errors: errors))
                    } else if let data = result.data {
                        fulfill(data)
                    } else {
                        fatalError("Something has gone horribly wrong.")
                    }
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }
        }
    }
}
