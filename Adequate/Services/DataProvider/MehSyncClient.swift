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

    private let credentialsProvider: AWSCredentialsProvider
    private var appSyncClient: AWSAppSyncClient?

    //var isAuthenticated: Bool = false

    // MARK: - Lifecycle

    init(credentialsProvider: AWSCredentialsProvider, connectionStateChangeHandler: ConnectionStateChangeHandler? = nil) {
        /*
        #if DEBUG
        // Setup logging
        MehSyncClient.configureLogging(logLevel: .verbose)
        #endif
        */

        self.credentialsProvider = credentialsProvider
        do {
            let appSyncConfig = try MehSyncClient.makeClientConfiguration(credentialsProvider: credentialsProvider,
                                                                          connectionStateChangeHandler: connectionStateChangeHandler)
            self.appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        } catch {
            log.error("\(error)")
        }

        appSyncClient?.apolloClient?.cacheKeyForObject = { $0[Constants.cacheKey] }
    }

    //func initializeCredentialsProvider() -> Promise<UserState> {}

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
