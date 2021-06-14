//
//  MehSyncClientMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 2/6/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import class Promise.Promise
@testable import Adequate

// swiftlint:disable all

class MehSyncClientMock: MehSyncClientType {
    typealias DealResultHandler = (Swift.Result<Deal, SyncClientError>) -> Void

    var hasClient: Bool = true

    // MARK: Returned from methods

    /// `Cancellable` returned from `fetchCurrentDeal(cachePolicy:queue:resultHandler:)`.
    var currentDealRequest: MockCancellable = MockCancellable()

    /// Promise returned from `fetchDeal(withID:cachePolicy:)`.
    var dealPromise: Promise<GetDealQuery.Data>!

    /// Promise returned from `fetchDealHistory(limit:nextToken:cachePolicy:)`.
    var historyPromise: Promise<DealHistoryQuery.Data>!

    /// Watcher returned from `watchCurrentDeal(cachePolicy:queue:resultHandler:)`.
    var currentDealWatcher: GraphQLQueryWatcherMock<Deal?>?

    /// Promise returned from `updateCache(cachePolicy:queue:resultHandler:)`.
    var updateCachePromise: Promise<Void>!

    // MARK: Closures executed when methods are called

    /// Exected when `fetchCurrentDeal(cachePolicy:queue:resultHandler:)` is called.
    var onFetchCurrentDeal: ((CachePolicy) -> Void)?

    /// Exected when `fetchDeal(withID:cachePolicy:)` is called.
    var onFetchDeal: ((GraphQLID, CachePolicy) -> Void)?

    /// Exected when `fetchDealHistory(limit:nextToken:cachePolicy:)` is called.
    var onFetchDealHistory: ((Int, String?, CachePolicy) -> Void)?

    /// Executed when `watchCurrentDeal(cachePolicy:queue:resultHandler:)` is called.
    var onWatchCurrentDeal: ((CachePolicy) -> Void)?

    /// Exected when `updateCache(cachePolicy:queue:resultHandler:)` is called.
    var onUpdateCache: ((Deal, DealDelta) -> Void)?

    // MARK: Results used by methods

    /// Result returned from `.fetchCurrentDeal(cachePolicy:queue:resultHandler:)`.
    var currentDealResult: Swift.Result<Deal?, SyncClientError>! // or use `OperationResult<Deal?>!`?

    /// Result returned from `fetchDeal(withID:cachePolicy:)`.
    var dealResult: Swift.Result<GetDealQuery.Data, SyncClientError>!

    /// Result returned from `fetchDealHistory(limit:nextToken:cachePolicy:)`.
    var historyResult: Swift.Result<DealHistoryQuery.Data, SyncClientError>!

    /// Result returned by `GraphQLQueryWatcher` returned from `watchCurrentDeal(cachePolicy:queue:resultHandler:)`.
    //var dealWatcherResponse: OperationResult<Deal?>?
    var dealWatcherResult: Swift.Result<Deal?, SyncClientError>!

    /// Result returned from `updateCache(cachePolicy:queue:resultHandler:)`.
    var updateCacheResult: Swift.Result<Void, SyncClientError>!

    // MARK: - Lifecycle

    convenience init(appSyncConfig: AWSAppSyncClientConfiguration) throws {
        self.init()
    }

    convenience init(credentialsProvider: CredentialsProvider, connectionStateChangeHandler: ConnectionStateChangeHandler? = nil) {
        self.init()
    }

    convenience init(appSyncClient: AWSAppSyncClient?) {
        self.init()
    }

    init() {}

    // MARK: - Fetch (Cancellable)

    func fetchCurrentDeal(
        cachePolicy: CachePolicy,
        queue: DispatchQueue = DispatchQueue.main,
        resultHandler: @escaping (OperationResult<Deal?>) -> Void
    ) -> Cancellable {
        onFetchCurrentDeal?(cachePolicy)
        guard hasClient else {
            resultHandler(.failure(SyncClientError.missingClient))
            return currentDealRequest
        }

        let requestResponse: OperationResult<Deal?>
        switch currentDealResult {
        case .success(let deal):
            // FIXME: improve handling
            switch cachePolicy {
            case .returnCacheDataElseFetch:
                requestResponse = .success(DataEnvelope<Deal?>(source: .server, data: deal))
            case .fetchIgnoringCacheData:
                requestResponse = .success(DataEnvelope<Deal?>(source: .server, data: deal))
            case .returnCacheDataDontFetch:
                requestResponse = .success(DataEnvelope<Deal?>(source: .cache, data: deal))
            case .returnCacheDataAndFetch:
                requestResponse = .success(DataEnvelope<Deal?>(source: .cache, data: deal))
            }
        case .failure(let error):
            requestResponse = .failure(error)
        case .none:
            requestResponse = .failure(.emptyResult)
        }

        currentDealRequest.resultHandler = {
            resultHandler(requestResponse)
        }

        return currentDealRequest
    }

    // MARK: - Fetch (Promise)

    func fetchDeal(
        withID id: GraphQLID,
        cachePolicy: CachePolicy = .fetchIgnoringCacheData
    ) -> Promise<GetDealQuery.Data> {
        onFetchDeal?(id, cachePolicy)
        guard hasClient else {
            return Promise<GetDealQuery.Data>(error: SyncClientError.missingClient)
        }

        dealPromise = .init()
        return dealPromise
    }

    func fetchDealHistory(limit: Int, nextToken: String?, cachePolicy: CachePolicy) -> Promise<DealHistoryQuery.Data> {
        onFetchDealHistory?(limit, nextToken, cachePolicy)
        guard hasClient else {
            return Promise<DealHistoryQuery.Data>(error: SyncClientError.missingClient)
        }

        // TODO: handle limit(?)
        // TODO: handle nextToken(?)

        historyPromise = .init()
        return historyPromise
    }

    // MARK: - Watch

    func watchCurrentDeal(
        cachePolicy: CachePolicy = .returnCacheDataAndFetch,
        queue: DispatchQueue = .main,
        resultHandler: @escaping (OperationResult<Deal?>) -> Void
    ) throws -> GraphQLQueryWatching {
        onWatchCurrentDeal?(cachePolicy)
        guard hasClient else {
            throw SyncClientError.missingClient
        }

        currentDealWatcher = GraphQLQueryWatcherMock(resultHandler: resultHandler)
        return currentDealWatcher!
    }

    // MARK: - Cache

    func updateCache(for deal: Deal, dealDelta delta: DealDelta) -> Promise<Void> {
        onUpdateCache?(deal, delta)
        guard deal.dealID == delta.dealID else {
            return Promise(error: DealDelta.DeltaApplicationError.invalidID)
        }
        guard hasClient else {
            return Promise<Void>(error: SyncClientError.missingClient)
        }
        updateCachePromise = .init()
        return updateCachePromise
    }
}

// MARK: - Helpers
extension MehSyncClientMock {

    // MARK: - Configuration

    func configureWithSuccess() throws {
        let currentDeal = try DealLoader.loadCurrentDeal()
        currentDealResult = .success(currentDeal)
        dealWatcherResult = .success(currentDeal)

        let historyDetail = try DealLoader.loadHistoryDetailData()
        dealResult = .success(historyDetail)

        let dealHistory = try DealLoader.loadHistoryListData()
        historyResult = .success(dealHistory)

        updateCacheResult = .success(())
    }

    func configureWithFailure() {
        currentDealResult = .failure(.network(error: NetworkErrorMock()))
        historyResult = .failure(.network(error: NetworkErrorMock()))
        dealResult = .failure(.network(error: NetworkErrorMock()))
        dealWatcherResult = .failure(.network(error: NetworkErrorMock()))
        updateCacheResult = .failure(.unknown(error: StoreErrorMock()))
    }

    // MARK: - Responses

    /// Simulate completion of `Promise` returned from `fetchCurrentDeal(cachePolicy:queue:resultHandler:)`.
    func returnFetchCurrentDealResponse() {
        currentDealRequest.respond()
    }

    /// Simulate completion of `Promise` returned from `fetchDeal(withID:cachePolicy:)`.
    func returnFetchDealResponse() {
        switch dealResult {
        case .success(let deal):
            dealPromise.fulfill(deal)
        case .failure(let error):
            dealPromise.reject(error)
        case .none:
            dealPromise.reject(SyncClientError.emptyResult)
        }
    }

    /// Simulate completion of `Promise` returned from `fetchDealHistory(limit:nextToken:cachePolicy:)`.
    func returnFetchDealHistoryResponse() {
        switch historyResult {
        case .success(let history):
            historyPromise.fulfill(history)
        case .failure(let error):
            historyPromise.reject(error)
        case .none:
            historyPromise.reject(SyncClientError.emptyResult)
        }
    }

    /// Simulate response from currentDeal `GraphQLQueryWatcher`.
    func returnCurrentDealWatcherResponse(source: DataEnvelope<Deal?>.Source = .server) {
        guard let watcher = currentDealWatcher else {
            assertionFailure("Missing currentDealWatcher")
            return
        }

        switch dealWatcherResult {
        case let .success(deal):
            watcher.respond(data: deal, source: source)
        case let .failure(error):
            watcher.respond(error: error)
        case .none:
            watcher.respond(error: .emptyResult)
        }
    }

    /// Simulate completion of `Promise` from `updateCache(cachePolicy:queue:resultHandler:)`.
    func returnUpdateCacheResponse() {
        switch updateCacheResult {
        case .success:
            updateCachePromise.fulfill(())
        case .failure(let error):
            updateCachePromise.reject(error)
        case .none:
            updateCachePromise.reject(SyncClientError.emptyResult)
        }
    }

}

// MARK: - Types
extension MehSyncClientMock {

    //enum Configuration {
    //    case success
    //    case failure
    //}

    struct StoreErrorMock: Error {}

    struct NetworkErrorMock: Error {}

    final class GraphQLQueryWatcherMock<T>: GraphQLQueryWatching {
        typealias Source = DataEnvelope<T>.Source

        var resultHandler: (OperationResult<T>) -> Void

        var wasCancelled: Bool = false

        var onCancel: (() -> Void)?

        var haveRefetched: Bool = false

        var onRefetch: (() -> Void)?

        init(resultHandler: @escaping (OperationResult<T>) -> Void) {
            self.resultHandler = resultHandler
        }

        // MARK: - GraphQLQueryWatching

        func refetch() {
            haveRefetched = true
            onRefetch?()
        }

        func cancel() {
            wasCancelled = true
            onCancel?()
        }

        // MARK: - Helpers

        func respond(error: SyncClientError) {
            respond(with: .failure(error))
        }

        func respond(data: T, source: Source = .server) {
            respond(with: .success(DataEnvelope<T>(source: source, data: data)))
        }

        private func respond(with result: OperationResult<T>) {
            resultHandler(result)
        }
    }
}

final class MockCancellable: Cancellable {

    var resultHandler: () -> Void

    var wasCancelled: Bool = false
    //var onCancel: (() -> Void)?

    init(_ resultHandler: @escaping () -> Void = { }) {
        self.resultHandler = resultHandler
    }

    func cancel() {
        wasCancelled = true
    }

    func respond() {
        guard !wasCancelled else {
            assertionFailure("Request was cancelled")
            return
        }
        resultHandler()
    }
}
