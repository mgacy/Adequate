//
//  MehSyncClient.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import AWSMobileClient
import class Promise.Promise // import class to avoid name collision with AWSAppSync.Promise

class MehSyncClient: MehSyncClientType {
    typealias DealHistory = DealHistoryQuery.Data.DealHistory

    private var appSyncClient: AWSAppSyncClient?

    // MARK: - Lifecycle

    convenience init(appSyncConfig: AWSAppSyncClientConfiguration) throws {
        let client = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        self.init(appSyncClient: client)
    }

    init(credentialsProvider: CredentialsProvider, connectionStateChangeHandler: ConnectionStateChangeHandler? = nil) {
        /*
        #if DEBUG
        // Setup logging
        MehSyncClient.configureLogging(logLevel: .verbose)
        #endif
        */

        do {
            let appSyncConfig = try MehSyncClient.makeClientConfiguration(credentialsProvider: credentialsProvider,
                                                                          connectionStateChangeHandler: connectionStateChangeHandler)
            self.appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        } catch {
            log.error("\(error)")
        }

        appSyncClient?.apolloClient?.cacheKeyForObject = { $0[Constants.cacheKey] }
    }

    init(appSyncClient: AWSAppSyncClient) {
        self.appSyncClient = appSyncClient
        appSyncClient.apolloClient?.cacheKeyForObject = { $0[Constants.cacheKey] }
    }

    // MARK: - Fetch (Cancellable)

    func fetchCurrentDeal(cachePolicy: CachePolicy,
                          queue: DispatchQueue = DispatchQueue.main,
                          resultHandler: @escaping OperationResultHandler<Deal?>
    ) -> Cancellable {
        let query = GetDealQuery(id: Constants.currentDealID)
        return fetch(query: query, cachePolicy: cachePolicy) { result in
            let dealResult = result.map({ envelope -> DataEnvelope<Deal?> in
                envelope.map({ Deal($0) })
            })
            resultHandler(dealResult)
        }
    }

    func fetch<Query: ResultSelectableQuery>(query: Query,
                                             cachePolicy: CachePolicy,
                                             queue: DispatchQueue = .main,
                                             resultHandler: @escaping OperationResultHandler<Query.Data.ResultType?>
    ) -> Cancellable {
        guard let client = appSyncClient else {
            resultHandler(.failure(SyncClientError.missingClient))
            return EmptyCancellable()
        }
        return client.fetch(query: query, cachePolicy: cachePolicy, queue: queue, resultHandler: resultHandler)
    }

    // MARK: - Fetch (Promise)

    func fetchDeal(withID id: GraphQLID, cachePolicy: CachePolicy = .fetchIgnoringCacheData) -> Promise<GetDealQuery.Data> {
        let query = GetDealQuery(id: id)
        return fetch(query: query, cachePolicy: cachePolicy)
    }

    func fetchDealHistory(limit: Int, nextToken: String?, cachePolicy: CachePolicy) -> Promise<DealHistoryQuery.Data> {
        let query = DealHistoryQuery(filter: nil, limit: 60, nextToken: nil)
        return fetch(query: query, cachePolicy: cachePolicy)
    }

    private func fetch<T: GraphQLQuery>(query: T, cachePolicy: CachePolicy, queue: DispatchQueue = .main) -> Promise<T.Data> {
        guard let appSyncClient = appSyncClient else {
            // TODO: make extension to retry initialization of client as a Promise?
            return Promise<T.Data>(error: SyncClientError.missingClient)
        }
        return appSyncClient.fetch(query: query, cachePolicy: cachePolicy, queue: queue)
    }

    // MARK: - Watch

    func watchCurrentDeal(cachePolicy: CachePolicy = .returnCacheDataAndFetch,
                          queue: DispatchQueue = .main,
                          resultHandler: @escaping OperationResultHandler<Deal?>
    ) throws -> GraphQLQueryWatcher<GetDealQuery> {
        guard let appSyncClient = appSyncClient else {
            throw SyncClientError.missingClient
        }

        let query = GetDealQuery(id: Constants.currentDealID)
        return appSyncClient.watch(query: query, cachePolicy: cachePolicy, queue: queue) { result in
            let dealResult = result.map({ envelope -> DataEnvelope<Deal?> in
                envelope.map({ Deal($0) })
            })
            resultHandler(dealResult)
        }
    }

    // TODO: add private watch<T: GraphQLQuery>(query:cachePolicy:queue:resultHandler:) -> GraphQLQueryWatcher<T> method?
    // TODO: would we need to handle the type of the result using type erasure?

    // MARK: - Cache

    func updateCache(for deal: Deal, delta: DealNotification) -> Promise<Void> {
        if case .newDeal = delta.deltaType {
            preconditionFailure("Unable to update DealDelta.newDeal")
        }
        guard let client = appSyncClient, let store = client.store else {
            // FIXME: this could (maybe?) be inaccurate since the problem might be a missing store
            return Promise<Void>(error: SyncClientError.missingClient)
        }

        // Wrapping Apollo.Promise in Promise is ugly, but we don't have access to `ApolloStore.queue` and thus can't
        // extend the class to accept a completion handler that we might use with Promise directly.
        // TODO: should I be using a capture list: `... { [store] fulfill, reject in`?
        return Promise<Void> { fulfill, reject in
            // NOTE: this uses AWSAppSync.Promise (from Apollo)
            store.withinReadWriteTransaction { transaction in
                let query = GetDealQuery(id: deal.id)
                try transaction.update(query: query) { (data: inout GetDealQuery.Data) in
                    // FIXME: compare `dealID`
                    switch delta.deltaType {
                    case .commentCount(let newCount):
                        data.getDeal?.topic?.commentCount = newCount
                    case .launchStatus(let newStatus):
                        data.getDeal?.launchStatus = newStatus
                    default:
                        break
                    }
                    fulfill(())
                }
            }.catch({ error in
                reject(error)
            })
        }
    }
}

// MARK: - Logging Configuration
extension MehSyncClient {
    private static func configureLogging(logLevel: AWSDDLogLevel = .verbose) {
        AWSDDLog.sharedInstance.logLevel = logLevel
        AWSDDTTYLogger.sharedInstance.logFormatter = AWSAppSyncClientLogFormatter()
        AWSDDLog.sharedInstance.add(AWSDDTTYLogger.sharedInstance)
    }
}

// MARK: - Configuration Factory
extension MehSyncClient {
    static func makeClientConfiguration(credentialsProvider: AWSCredentialsProvider, connectionStateChangeHandler: ConnectionStateChangeHandler? = nil) throws -> AWSAppSyncClientConfiguration {

        var awsCredentialsProvider: AWSCredentialsProvider? = credentialsProvider
        var serviceConfig: AWSAppSyncServiceConfigProvider?
        #if DEBUG
        if CommandLine.arguments.contains("ENABLE-UI-TESTING") {
            serviceConfig = UITestingConfig()
            awsCredentialsProvider = nil
        }
        #endif

        let appSyncServiceConfig = serviceConfig != nil ? serviceConfig! : try AWSAppSyncServiceConfig()
        let cacheConfiguration = try AWSAppSyncCacheConfiguration()
        let retryStrategy: AWSAppSyncRetryStrategy = .aggressive  // OPTIONS: .aggressive, .exponential

        // https://aws-amplify.github.io/docs/ios/api#iam
        // https://github.com/aws-samples/aws-mobile-appsync-events-starter-ios/blob/master/EventsApp/AppDelegate.swift
        return try AWSAppSyncClientConfiguration(appSyncServiceConfig: appSyncServiceConfig,
                                                 credentialsProvider: awsCredentialsProvider,
                                                 urlSessionConfiguration: URLSessionConfiguration.default,
                                                 cacheConfiguration: cacheConfiguration,
                                                 connectionStateChangeHandler: connectionStateChangeHandler,
                                                 retryStrategy: retryStrategy)
    }
}

// MARK: - Types
extension MehSyncClient {

    enum Constants {
        static let cacheKey: String = "id"
        static let currentDealID: String = "current_deal"
    }

    /// A class to return when we need to bail out of something which still needs to return `Cancellable`.
    private final class EmptyCancellable: Cancellable {
        func cancel() {
            // An error occured to there is nothing to cancel.
        }
    }
}
