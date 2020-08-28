//
//  AWSAppSyncClient+Result.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/29/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import AWSAppSync

public extension AWSAppSyncClient {

    typealias QueryResultHandler<Query> = (Swift.Result<Query.Data, SyncClientError>) -> Void where Query : GraphQLQuery
    typealias MutationResultHandler<Mutation> = (Swift.Result<Mutation.Data, SyncClientError>) -> Void where Mutation : GraphQLMutation

    /// Fetches a query from the server or from the local cache, depending on the current contents of the cache and the
    /// specified cache policy.
    ///
    /// - Parameters:
    ///   - query: The query to fetch.
    ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server and when data should be loaded from the local cache.
    ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
    ///   - resultHandler: A  closure that is called when query results are available or when an error occurs.
    /// - Returns: An object that can be used to cancel an in progress fetch.

    @discardableResult
    func fetch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                    queue: DispatchQueue = DispatchQueue.main,
                                    resultHandler: @escaping QueryResultHandler<Query>
    ) -> Cancellable {
        return fetch(query: query, cachePolicy: cachePolicy, queue: queue) { result, error in
            if let error = error {
                // TODO: should I wrap in SyncClientError here or higher up?
                resultHandler(.failure(SyncClientError.wrap(error)))
            } else if let result = result {
                if let data = result.data {
                    resultHandler(.success(data))
                } else if let errors = result.errors {
                    resultHandler(.failure(.graphQL(errors: errors)))
                } else {
                    //fatalError("Something has gone horribly wrong: neither data nor errors.")
                    resultHandler(.failure(.myError(message: "Neither data nor errors")))
                }
            } else {
                //fatalError("Something has gone horribly wrong: neither result nor error.")
                resultHandler(.failure(.myError(message: "Neither result nor error")))
            }
        }
    }

    /// Watches a query by first fetching an initial result from the server or from the local cache, depending on the current contents
    /// of the cache and the specified cache policy. After the initial fetch, the returned query watcher object will get notified whenever
    /// any of the data the query result depends on changes in the local cache, and calls the result handler again with the new result.
    ///
    /// - Parameters:
    ///   - query: The query to fetch.
    ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server or from the local cache.
    ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
    ///   - resultHandler: A closure that is called when query results are available or when an error occurs.
    /// - Returns: A query watcher object that can be used to control the watching behavior.
    func watch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                    queue: DispatchQueue = DispatchQueue.main,
                                    resultHandler: @escaping QueryResultHandler<Query>
    ) -> GraphQLQueryWatcher<Query> {
        return watch(query: query, cachePolicy: cachePolicy, queue: queue) { result, error in
            if let error = error {
                // TODO: should I wrap in SyncClientError here or higher up?
                resultHandler(.failure(SyncClientError.wrap(error)))
            } else if let result = result {
                if let data = result.data {
                    resultHandler(.success(data))
                } else if let errors = result.errors {
                    resultHandler(.failure(.graphQL(errors: errors)))
                } else {
                    //fatalError("Something has gone horribly wrong: neither data nor errors.")
                    resultHandler(.failure(.myError(message: "Neither data nor errors")))
                }
            } else {
                //fatalError("Something has gone horribly wrong: neither result nor error.")
                resultHandler(.failure(.myError(message: "Neither result nor error")))
            }
        }
    }

    /// Performs a mutation by sending it to the server. Internally, these mutations are added to a queue and performed
    /// serially, in first-in, first-out order. Clients can inspect the size of the queue with the `queuedMutationCount`
    /// property.
    ///
    /// - Parameters:
    ///   - mutation: The mutation to perform.
    ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
    ///   - optimisticUpdate: An optional closure which gets executed before making the network call, should be used to update local store using the `transaction` object.
    ///   - conflictResolutionBlock: An optional closure that is called when mutation results into a conflict.
    ///   - resultHandler: A closure that is called when mutation results are available or when an error occurs.
    /// - Returns: An object that can be used to cancel an in progress mutation.
    @discardableResult
    func perform<Mutation: GraphQLMutation>(mutation: Mutation,
                                            queue: DispatchQueue = .main,
                                            optimisticUpdate: OptimisticResponseBlock? = nil,
                                            conflictResolutionBlock: MutationConflictHandler<Mutation>? = nil,
                                            resultHandler: @escaping MutationResultHandler<Mutation>
    ) -> Cancellable {
        return perform(mutation: mutation, queue: queue, optimisticUpdate: optimisticUpdate,
                       conflictResolutionBlock: conflictResolutionBlock) { result, error in
                        if let error = error {
                            // TODO: should I wrap in SyncClientError here or higher up?
                            resultHandler(.failure(SyncClientError.wrap(error)))
                        } else if let result = result {
                            if let errors = result.errors {
                                resultHandler(.failure(.graphQL(errors: errors)))
                            } else if let data = result.data {
                                resultHandler(.success(data))
                            } else {
                                //fatalError("Something has gone horribly wrong: neither data nor errors.")
                                resultHandler(.failure(.myError(message: "Neither data nor errors")))
                            }
                        } else {
                            //fatalError("Something has gone horribly wrong: neither result nor error.")
                            resultHandler(.failure(.myError(message: "Neither result nor error")))
                        }
        }
    }

}
