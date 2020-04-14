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
    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod

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

    // MARK: - Fetch

    func fetchCurrentDeal(cachePolicy: CachePolicy) -> Promise<GetDealQuery.Data> {
        let query = GetDealQuery(id: Constants.currentDealID)
        return fetch(query: query, cachePolicy: cachePolicy)
    }

    func fetchDeal(withID id: GraphQLID, cachePolicy: CachePolicy = .fetchIgnoringCacheData) -> Promise<GetDealQuery.Data> {
        let query = GetDealQuery(id: id)
        return fetch(query: query, cachePolicy: cachePolicy)
    }

    func fetchDealHistory(from startDate: Date, to endDate: Date, cachePolicy: CachePolicy) -> Promise<ListDealsForPeriodQuery.Data> {
        let startDateString = DateFormatter.yyyyMMddEST.string(from: startDate)
        let endDateString = DateFormatter.yyyyMMddEST.string(from: endDate)
        let query = ListDealsForPeriodQuery(startDate: startDateString, endDate: endDateString)
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

    // Specify `Swift.Result` to avoid interference with `AWSAppSync.Result`
    typealias DealResultHandler = (Swift.Result<Deal, SyncClientError>) -> Void

    func watchCurrentDeal(cachePolicy: CachePolicy = .returnCacheDataAndFetch, queue: DispatchQueue = .main, resultHandler: @escaping DealResultHandler) throws -> GraphQLQueryWatcher<GetDealQuery> {
        guard let appSyncClient = appSyncClient else {
            throw SyncClientError.missingClient
        }

        let query = GetDealQuery(id: Constants.currentDealID)
        return appSyncClient.watch(query: query, cachePolicy: cachePolicy, queue: queue) { result, error in
            if let appSyncError = error as? AWSAppSyncClientError {
                /*
                // TODO: handle different AWSAppSyncClientError
                // https://techlife.cookpad.com/entry/2019/06/14/160000
                // For `.requestFailed`, the Cocoa error can be extracted and `.localizedDescription` shown to the user.
                // Other cases probably aren't that useful. `AWSAppSyncClientError` conforms to `LocalizedError`,
                // but the error messages are English only and usually add various codes that would probably be unideal
                // to show users.
                 */
                switch appSyncError {
                case .requestFailed(_, _, let error):
                    // TODO: look at response / data
                    log.error("\(#function) - AWSAppSyncClientError.appSyncError: \(error?.localizedDescription ?? "No Error") ")
                case .noData(let response):
                    log.error("\(#function) - AWSAppSyncClientError.noData: \(response) ")
                case .parseError(_, _, let error):
                    log.error("\(#function) - AWSAppSyncClientError.parseError: \(error?.localizedDescription ?? "No Error") ")
                case .authenticationError(let error):
                    log.error("\(#function) - AWSAppSyncClientError.authenticationError: \(error.localizedDescription) ")
                }
                resultHandler(.failure(SyncClientError.network(error: appSyncError)))
            } else if let unknownError = error {
                resultHandler(.failure(SyncClientError.unknown(error: unknownError)))
            } else if let result = result, let data = result.data {
                // According to the GraphQL spec, result can contain both data and a non-empty list of (untyped) errors
                if let graphQLErrors = result.errors, !graphQLErrors.isEmpty {
                    log.error("\(#function) - fetch returned data and errors: \(graphQLErrors.map { $0.localizedDescription })")
                }

                guard let deal = Deal(data.getDeal) else {
                    return resultHandler(.failure(SyncClientError.missingData(data: data)))
                }
                resultHandler(.success(deal))
            } else {
                resultHandler(.failure(SyncClientError.myError(message: "Something has gone horribly wrong.")))
            }
        }
    }

    // TODO: add private watch<T: GraphQLQuery>(query:cachePolicy:queue:resultHandler:) -> GraphQLQueryWatcher<T> method?
    // TODO: how would we handle the type of the result?

    // MARK: - Cache

    // TODO: simply return Promise?
    func updateCache(for deal: Deal, delta: DealDelta) throws {
        // TODO: improve handling / reporting of cases below
        guard let client = appSyncClient, let store = client.store else {
            log.error("Unable to get store")
            return
            // FIXME: throw error (what type?)
        }
        // TODO: throw error and make caller handler it
        if case .newDeal = delta {
            log.error("Unable to update cache for \(delta)")
            return
            // FIXME: throw error (what type?)
        }

        // NOTE: this uses AWSAppSync.Promise (from Apollo)
        store.withinReadWriteTransaction { transaction in
            let query = GetDealQuery(id: deal.id)
            try transaction.update(query: query) { (data: inout GetDealQuery.Data) in
                switch delta {
                case .commentCount(let newCount):
                    data.getDeal?.topic?.commentCount = newCount
                case .launchStatus(let newStatus):
                    data.getDeal?.launchStatus = newStatus
                default:
                    break
                }
            }
        }.catch({ error in
            // FIXME: is there anything else we can do?
            log.error("\(error.localizedDescription)")
        })
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
        let cacheConfiguration = try AWSAppSyncCacheConfiguration()
        let retryStrategy: AWSAppSyncRetryStrategy = .aggressive  // OPTIONS: .aggressive, .exponential

        // https://aws-amplify.github.io/docs/ios/api#iam
        // https://github.com/aws-samples/aws-mobile-appsync-events-starter-ios/blob/master/EventsApp/AppDelegate.swift
        return try AWSAppSyncClientConfiguration(appSyncServiceConfig: AWSAppSyncServiceConfig(),
                                                 credentialsProvider: credentialsProvider,
                                                 urlSessionConfiguration: URLSessionConfiguration.default,
                                                 cacheConfiguration: cacheConfiguration,
                                                 connectionStateChangeHandler: connectionStateChangeHandler,
                                                 retryStrategy: retryStrategy)
    }
}

// MARK: - Constants
extension MehSyncClient {
    private enum Constants {
        static var cacheKey: String { return "id" }
        static var currentDealID: String { return "current_deal" }
    }
}
