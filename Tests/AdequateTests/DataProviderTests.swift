//
//  DataProviderTests.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 2/6/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

@testable import Adequate
import XCTest
import Combine
import AWSAppSync
import AWSMobileClient
import class Promise.Promise

// swiftlint:disable all

class DataProviderTests: XCTestCase {

    var credentialsProvider: CredentialsProviderMock!

    var client: MehSyncClientMock!

    //var refreshManager:

    var sut: DataProvider!

    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        credentialsProvider = CredentialsProviderMock()
        client = MehSyncClientMock()
        //sut = DataProvider(credentialsProvider: credentialsProvider!, client: client!)
    }

    override func tearDownWithError() throws {
        credentialsProvider = nil
        client = nil
        sut = nil
        cancellables = []
    }
}

// MARK: - Initialization
extension DataProviderTests {

    func testInit_Succes() throws {
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        credentialsProvider.completeInit()
        XCTAssertEqual(sut.dealState, ViewState<Deal>.empty)
    }

    func testInit_Failure() throws {
        let initError = AWSMobileClientError.tooManyFailedAttempts(message: "Failed")
        credentialsProvider.initializationResult = .failure(initError)
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        let expectation = self.expectation(description: "Init")
        var result: ViewState<Deal>?
        sut.$dealState
            //.receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { viewState in
                result = viewState
                expectation.fulfill()
            }
            .store(in: &cancellables)

        credentialsProvider.completeInit()

        waitForExpectations(timeout: 5, handler: nil)

        guard case .error = result else {
            XCTFail("Unexpected viewState: \(String(describing: result))")
            return
        }
    }
}

// MARK: - RefreshEvent
extension DataProviderTests {

    // MARK: - RefreshEvent.launch

    func testLaunch() throws {
        // Fail if we try to fetch before credentialsProvider success
        client.onFetchDealHistory = { _, _, _ in
            XCTFail("Fetched DealHistory prematurely")
        }
        client.onWatchCurrentDeal = { _ in
            XCTFail("currentDealWatcher created prematurely")
        }

        try client.configureWithSuccess()
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations - Deal
        let watcherExpectation = self.expectation(description: "DealWatcher Init")
        let loadingExpectation = self.expectation(description: "dealState: .loading")
        let resultExpectation = self.expectation(description: "dealState: .result")

        var dealResult: Deal?
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .sink { dealState in
                switch dealState {
                case .loading:
                    loadingExpectation.fulfill()
                case let .result(deal):
                    resultExpectation.fulfill()
                    dealResult = deal
                case .empty:
                    XCTFail("Unexpected .empty dealState")
                case .error(let error):
                    XCTFail("Unexpected .error dealState: \(error)")
                }
            }
            .store(in: &cancellables)

        // Expectations - History
        let historyLoadingExpectation = self.expectation(description: "historyState: .loading")
        let historyResultExpectation = self.expectation(description: "historyState: .result")

        var historyResult: [DealHistoryQuery.Data.DealHistory.Item]?
        sut.$historyState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .sink { historyState in
                switch historyState {
                case .loading:
                    historyLoadingExpectation.fulfill()
                case .result(let result):
                    historyResultExpectation.fulfill()
                    historyResult = result
                case .empty:
                    XCTFail("Unexpected .empty historyState")
                case .error(let error):
                    XCTFail("Unexpected .error historyState: \(error)")
                }
            }
            .store(in: &cancellables)

        // `AppCoordinator.showMain(dealNotification:)` sends .launch
        sut.refreshDeal(for: .launch)

        // `credentialsProvider.initialize()` succeeded; we now expect configuration of `currentDealWatcher`
        credentialsProvider.completeInit()
        client.onWatchCurrentDeal = { cachePolicy in
            watcherExpectation.fulfill()
        }

        wait(for: [watcherExpectation, loadingExpectation], timeout: 5)

        // Now that we have loaded currentDeal, we expect request to fetch Deal history
        let requestHistoryExpectation = self.expectation(description: "History Request")
        client.onFetchDealHistory = { _, _, _ in
            requestHistoryExpectation.fulfill()
        }

        XCTAssertEqual(sut.historyState, .empty, "Premature loading of dealHistory")

        // Client returns current `Deal` from cache
        client.returnCurrentDealWatcherResponse(source: .cache)

        wait(for: [resultExpectation], timeout: 5)

        let clientResult = try client.dealWatcherResult.get()
        XCTAssertEqual(dealResult, clientResult)

        // Client returns `DealHistory`
        client.returnFetchDealHistoryResponse()

        waitForExpectations(timeout: 5, handler: nil)
        //wait(for: [resultExpectation, requestHistoryExpectation], timeout: 5)
        //wait(for: [historyLoadingExpectation, historyResultExpectation], timeout: 5)

        let clientHistoryResult = try client.historyResult.get().dealHistory?.items?.compactMap { $0 }
        XCTAssertEqual(historyResult, clientHistoryResult)

        // TODO:
        // Client returns current `Deal` from server
        //client.returnCurrentDealWatcherResponse(source: .server)

        // TODO: verify `CurrentDealManager.saveDeal(_:)` called
    }

    // MARK: - RefreshEvent.launchFromNotification

    // MARK: RefreshEvent.launchFromNotification - DeltaType.newDeal

    func testLaunchFromNewNotification() throws {
        // Fail if we try to fetch before credentialsProvider success
        client.onFetchDealHistory = { _, _, _ in
            XCTFail("Fetched DealHistory prematurely")
        }
        client.onWatchCurrentDeal = { _ in
            XCTFail("currentDealWatcher created prematurely")
        }
        client.onFetchCurrentDeal = { _ in
            XCTFail("Fetched currentDeal prematurely")
        }

        // Prepare data
        let dealID: DealId = .other
        let dealNotification = makeNewNotification(id: dealID)

        // Notification would indicate a new deal differing from that in the cache
        try client.configureWithSuccess()
        client.currentDealResult = client.currentDealResult.map { Deal.lens.dealID.set(dealID.rawValue)($0!) }

        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations - Deal
        let watcherConfigExpectation = self.expectation(description: "DealWatcher Init")
        let loadingExpectation = self.expectation(description: "dealState: .loading")
        let fetchCurrentDealExpectation = self.expectation(description: "Called `fetchCurrentDeal()`")
        //var watcherResultExpectation: XCTestExpectation?
        let watcherResultExpectation = self.expectation(description: "dealState: .result")

        var cachedResult: Deal?
        //var initialDealSubscription: AnyCancellable? = sut.$dealState
        //let initialDealSubscription = sut.$dealState
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .sink { dealState in
                switch dealState {
                case .loading:
                    loadingExpectation.fulfill()
                case let .result(deal):
                    // FIXME: better way to avoid multiple fulfillments of expectation
                    if cachedResult == nil {
                        watcherResultExpectation.fulfill()
                        cachedResult = deal
                    }
                case .empty:
                    XCTFail("Unexpected .empty dealState")
                case .error:
                    XCTFail("Unexpected .error dealState")
                }
            }
            .store(in: &cancellables)

        // `AppCoordinator.showMain(dealNotification:)` sends .launchFromNotification
        sut.refreshDeal(for: .launchFromNotification(dealNotification))

        // `credentialsProvider.initialize()` succeeded; we now expect
        // - configuration of `currentDealWatcher` (using cache) - FIXME: why?
        // - fetching of current deal from server
        credentialsProvider.completeInit()
        client.onWatchCurrentDeal = { cachePolicy in
            XCTAssertEqual(cachePolicy, .returnCacheDataDontFetch)
            watcherConfigExpectation.fulfill()
        }
        client.onFetchCurrentDeal = { cachePolicy in
            XCTAssertEqual(cachePolicy, .fetchIgnoringCacheData)
            fetchCurrentDealExpectation.fulfill()
        }
        wait(for: [watcherConfigExpectation, loadingExpectation, fetchCurrentDealExpectation], timeout: 5)

        // Cached result from `currentDealWatcher`
        client.returnCurrentDealWatcherResponse(source: .cache)

        wait(for: [watcherResultExpectation], timeout: 5)

        let clientCachedResult = try client.dealWatcherResult.get()
        XCTAssertEqual(cachedResult, clientCachedResult)

        // Response from server
        let serverResultExpectation = self.expectation(description: "dealState: .result")
        var serverResult: Deal?
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore current value
            .sink { dealState in
                switch dealState {
                case .loading:
                    XCTFail("Unexpected .loading dealState")
                case let .result(deal):
                    serverResultExpectation.fulfill()
                    serverResult = deal
                case .empty:
                    XCTFail("Unexpected .empty dealState")
                case .error:
                    XCTFail("Unexpected .error dealState")
                }
            }
            .store(in: &cancellables)

        // Return response from server
        client.returnFetchCurrentDealResponse()

        wait(for: [serverResultExpectation], timeout: 5)

        let clientServerResult = try client.currentDealResult.get()
        XCTAssertEqual(serverResult, clientServerResult)

        // ...

        // TODO: on iOS 14, we will also expect widgets to be refreshed; test this
        // TODO: can we test the background task?
        // TODO: verify `CurrentDealManager.saveDeal(_:)` called

    }

    // MARK: RefreshEvent.launchFromNotification - DeltaType.commentCount

    func testLaunchFromDeltaCommentNotification() throws {
        // Fail if we try to fetch before credentialsProvider success
        client.onFetchDealHistory = { _, _, _ in
            XCTFail("Fetched DealHistory prematurely")
        }
        client.onWatchCurrentDeal = { _ in
            XCTFail("currentDealWatcher created prematurely")
        }
        client.onFetchCurrentDeal = { _ in
            XCTFail("Fetched currentDeal prematurely")
        }

        // Prepare data
        let dealID: DealId = .currentDeal
        let newCommentCount = 25
        let delta = makeCommentDelta(id: dealID, count: newCommentCount)
        let dealNotification = DealNotification.delta(delta)

        // Mutate topic.commentCount to match notification
        try client.configureWithSuccess()
        client.currentDealResult = client.currentDealResult.map { try? delta.apply(to: $0!) ?? $0 }

        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations - Deal
        let watcherConfigExpectation = self.expectation(description: "DealWatcher Init")
        let loadingExpectation = self.expectation(description: "dealState: .loading")
        let fetchCurrentDealExpectation = self.expectation(description: "Called `fetchCurrentDeal()`")
        let watcherResultExpectation = self.expectation(description: "dealState: .result")

        var cachedResult: Deal?
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .sink { dealState in
                switch dealState {
                case .loading:
                    loadingExpectation.fulfill()
                case let .result(deal):
                    // FIXME: better way to avoid multiple fulfillments of expectation
                    if cachedResult == nil {
                        watcherResultExpectation.fulfill()
                        cachedResult = deal
                    }
                case .empty:
                    XCTFail("Unexpected .empty dealState")
                case .error:
                    XCTFail("Unexpected .error dealState")
                }
            }
            .store(in: &cancellables)

        // `AppCoordinator.showMain(dealNotification:)` sends .launchFromNotification
        sut.refreshDeal(for: .launchFromNotification(dealNotification))

        // `credentialsProvider.initialize()` succeeded; we now expect:
        // - configuration of `currentDealWatcher` (using cache)
        // - fetching of current deal from server
        credentialsProvider.completeInit()
        client.onWatchCurrentDeal = { cachePolicy in
            XCTAssertEqual(cachePolicy, .returnCacheDataDontFetch)
            watcherConfigExpectation.fulfill()
        }
        client.onFetchCurrentDeal = { cachePolicy in
            XCTAssertEqual(cachePolicy, .fetchIgnoringCacheData)
            fetchCurrentDealExpectation.fulfill()
        }
        wait(for: [watcherConfigExpectation, loadingExpectation, fetchCurrentDealExpectation], timeout: 5)

        // Cached result from `currentDealWatcher`
        client.returnCurrentDealWatcherResponse(source: .cache)

        wait(for: [watcherResultExpectation], timeout: 5)

        let clientCachedResult = try client.dealWatcherResult.get()
        XCTAssertEqual(cachedResult?.topic?.commentCount, 17)
        XCTAssertEqual(cachedResult, clientCachedResult)

        // Response from server
        let serverResultExpectation = self.expectation(description: "dealState: .result")
        var serverResult: Deal?
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore current value
            .sink { dealState in
                switch dealState {
                case .loading:
                    XCTFail("Unexpected .loading dealState")
                case let .result(deal):
                    serverResultExpectation.fulfill()
                    serverResult = deal
                case .empty:
                    XCTFail("Unexpected .empty dealState")
                case .error:
                    XCTFail("Unexpected .error dealState")
                }
            }
            .store(in: &cancellables)

        // Return response from server
        client.returnFetchCurrentDealResponse()

        wait(for: [serverResultExpectation], timeout: 5)

        let clientServerResult = try client.currentDealResult.get()
        XCTAssertEqual(serverResult?.topic?.commentCount, newCommentCount)
        XCTAssertEqual(serverResult, clientServerResult)

        // TODO: on iOS 14, we will also expect widgets to be refreshed; test this
        // TODO: can we test the background task?
        // TODO: verify `CurrentDealManager.saveDeal(_:)` called
    }

    // MARK: RefreshEvent.launchFromNotification - DeltaType.launchStatus

    func testLaunchFromDeltaStatusNotification() throws {
        // Fail if we try to fetch before credentialsProvider success
        client.onFetchDealHistory = { _, _, _ in
            XCTFail("Fetched DealHistory prematurely")
        }
        client.onWatchCurrentDeal = { _ in
            XCTFail("currentDealWatcher created prematurely")
        }
        client.onFetchCurrentDeal = { _ in
            XCTFail("Fetched currentDeal prematurely")
        }

        // Prepare data
        let dealID: DealId = .currentDeal
        let newStatus: LaunchStatus = .launchSoldOut
        let delta = makeStatusDelta(id: dealID, status: newStatus)
        let dealNotification = DealNotification.delta(delta)

        // Mutate launchStatus to match notification
        try client.configureWithSuccess()
        client.currentDealResult = client.currentDealResult.map { try? delta.apply(to: $0!) ?? $0 }

        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations - Deal
        let watcherConfigExpectation = self.expectation(description: "DealWatcher Init")
        let loadingExpectation = self.expectation(description: "dealState: .loading")
        let fetchCurrentDealExpectation = self.expectation(description: "Called `fetchCurrentDeal()`")
        let watcherResultExpectation = self.expectation(description: "dealState: .result")

        var cachedResult: Deal?
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .sink { dealState in
                switch dealState {
                case .loading:
                    loadingExpectation.fulfill()
                case let .result(deal):
                    // FIXME: better way to avoid multiple fulfillments of expectation
                    if cachedResult == nil {
                        watcherResultExpectation.fulfill()
                        cachedResult = deal
                    }
                case .empty:
                    XCTFail("Unexpected .empty dealState")
                case .error:
                    XCTFail("Unexpected .error dealState")
                }
            }
            .store(in: &cancellables)

        // `AppCoordinator.showMain(dealNotification:)` sends .launchFromNotification
        sut.refreshDeal(for: .launchFromNotification(dealNotification))

        // `credentialsProvider.initialize()` succeeded; we now expect
        // - configuration of `currentDealWatcher` (using cache)
        // - fetching of current deal from server
        credentialsProvider.completeInit()
        client.onWatchCurrentDeal = { cachePolicy in
            XCTAssertEqual(cachePolicy, .returnCacheDataDontFetch)
            watcherConfigExpectation.fulfill()
        }
        client.onFetchCurrentDeal = { cachePolicy in
            XCTAssertEqual(cachePolicy, .fetchIgnoringCacheData)
            fetchCurrentDealExpectation.fulfill()
        }
        wait(for: [watcherConfigExpectation, loadingExpectation, fetchCurrentDealExpectation], timeout: 5)

        // Cached result from `currentDealWatcher`
        client.returnCurrentDealWatcherResponse(source: .cache)

        wait(for: [watcherResultExpectation], timeout: 5)

        let clientCachedResult = try client.dealWatcherResult.get()
        XCTAssertEqual(cachedResult?.launchStatus, LaunchStatus.launch)
        XCTAssertEqual(cachedResult, clientCachedResult)

        // Response from server
        let serverResultExpectation = self.expectation(description: "dealState: .result")
        var serverResult: Deal?
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore current value
            .sink { dealState in
                switch dealState {
                case .loading:
                    XCTFail("Unexpected .loading dealState")
                case let .result(deal):
                    serverResultExpectation.fulfill()
                    serverResult = deal
                case .empty:
                    XCTFail("Unexpected .empty dealState")
                case .error:
                    XCTFail("Unexpected .error dealState")
                }
            }
            .store(in: &cancellables)

        // Return response from server
        client.returnFetchCurrentDealResponse()

        wait(for: [serverResultExpectation], timeout: 5)

        let clientServerResult = try client.currentDealResult.get()
        XCTAssertEqual(serverResult?.launchStatus, newStatus)
        XCTAssertEqual(serverResult, clientServerResult)

        // ...

        // TODO: on iOS 14, we will also expect widgets to be refreshed; test this
        // TODO: can we test the background task?
        // TODO: verify `CurrentDealManager.saveDeal(_:)` called
    }

    //func testLaunchFromNotificationWithError() throws {}

    // MARK: - RefreshEvent.silentNotification

    func testSilentCommentNotification() throws {
        // Prepare data
        let dealID: DealId = .currentDeal
        let newCommentCount = 25
        let delta = makeCommentDelta(id: dealID, count: newCommentCount)
        let notification: DealNotification = .delta(delta)

        try client.configureWithSuccess()
        let expectedResult = try client.currentDealResult.map { try? delta.apply(to: $0!) ?? $0 }.get()

        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations
        let updateCacheExectation = self.expectation(description: "Update cache with result of delta")
        let fetchResultExpectation = self.expectation(description: "Backround fetch result handler called")
        var updateDealResult: Deal?
        var updateDeltaResult: DealDelta?
        var fetchResult: UIBackgroundFetchResult?

        client.onUpdateCache = { deal, delta in
            updateCacheExectation.fulfill()
            updateDealResult = deal
            updateDeltaResult = delta
        }

        let handlerClosure: (UIBackgroundFetchResult) -> Void = { result in
            fetchResultExpectation.fulfill()
            fetchResult = result
        }

        // Standard startup
        let initExpectation = self.expectation(description: "Inital config finished")
        completeStandardSetup(initExpectation)
        wait(for: [initExpectation], timeout: 2)
        // Verify dataProvider is in expected initial state
        let serverDeal = try client.dealWatcherResult.get()!
        XCTAssertEqual(sut.dealState, ViewState.result(serverDeal))

        // START

        // `AppCoordinator.refreshDeal(for:)` sends .silentNotification
        sut.refreshDeal(for: .silentNotification(notification: notification, handler: handlerClosure))

        // TODO: check all states
        // - checks viewState
        //   - loading: waits
        //   - result: standard
        //   - other: `fetchDealInBackground()`

        // - Apply delta to current deal
        // - call update cache

        // TODO: verify behavior when dealID does not match

        wait(for: [updateCacheExectation], timeout: 1)

        // Cache update succeeded
        client.returnUpdateCacheResponse()

        wait(for: [fetchResultExpectation], timeout: 1)
        XCTAssertEqual(fetchResult, UIBackgroundFetchResult.newData)
        XCTAssertEqual(updateDealResult, expectedResult)
        XCTAssertEqual(updateDeltaResult, delta)

        // TODO: that would then result in the deal watcher being called, right?
        //client.dealWatcherResult = .success(expectedResult)
        //client.returnCurrentDealWatcherResponse(source: .cache)
    }

    func testSilentStatusNotification() throws {
        // Prepare data
        let dealID: DealId = .currentDeal
        let launchStatus: LaunchStatus = .launchSoldOut
        let delta = makeStatusDelta(id: dealID, status: launchStatus)
        let notification: DealNotification = .delta(delta)

        try client.configureWithSuccess()
        let expectedResult = try client.currentDealResult.map { try? delta.apply(to: $0!) ?? $0 }.get()

        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations
        let updateCacheExectation = self.expectation(description: "Update cache with result of delta")
        let fetchResultExpectation = self.expectation(description: "Backround fetch result handler called")
        var updateDealResult: Deal?
        var updateDeltaResult: DealDelta?
        var fetchResult: UIBackgroundFetchResult?

        client.onUpdateCache = { deal, delta in
            updateCacheExectation.fulfill()
            updateDealResult = deal
            updateDeltaResult = delta
        }

        let handlerClosure: (UIBackgroundFetchResult) -> Void = { result in
            fetchResultExpectation.fulfill()
            fetchResult = result
        }

        // Standard startup
        let initExpectation = self.expectation(description: "Inital config finished")
        completeStandardSetup(initExpectation)
        wait(for: [initExpectation], timeout: 2)
        // Verify dataProvider is in expected initial state
        let serverDeal = try client.dealWatcherResult.get()!
        XCTAssertEqual(sut.dealState, ViewState.result(serverDeal))

        // START

        // `AppCoordinator.refreshDeal(for:)` sends .silentNotification
        sut.refreshDeal(for: .silentNotification(notification: notification, handler: handlerClosure))

        wait(for: [updateCacheExectation], timeout: 1)

        // Cache update succeeded
        client.returnUpdateCacheResponse()

        wait(for: [fetchResultExpectation], timeout: 1)
        XCTAssertEqual(fetchResult, UIBackgroundFetchResult.newData)
        XCTAssertEqual(updateDealResult, expectedResult)
        XCTAssertEqual(updateDeltaResult, delta)

        // TODO: that would then result in the deal watcher being called, right?
        //client.dealWatcherResult = .success(expectedResult)
        //client.returnCurrentDealWatcherResponse(source: .cache)
    }

    func testSilentStatusNotificationWhileLoading() throws {
        // Prepare data
        let dealID: DealId = .currentDeal
        let launchStatus: LaunchStatus = .launchSoldOut
        let delta = makeStatusDelta(id: dealID, status: launchStatus)
        let notification: DealNotification = .delta(delta)

        try client.configureWithSuccess()
        //let expectedResult = try client.currentDealResult.map { try? delta.apply(to: $0!) ?? $0 }.get()

        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations
        let fetchResultExpectation = self.expectation(description: "Backround fetch result handler called")
        var fetchResult: UIBackgroundFetchResult?

        client.onUpdateCache = { _, _ in
            XCTFail("Updated cache prematurely")
        }

        let handlerClosure: (UIBackgroundFetchResult) -> Void = { result in
            fetchResultExpectation.fulfill()
            fetchResult = result
        }

        // Standard startup
        sut.refreshDeal(for: .launch)
        credentialsProvider.completeInit()
        let watcherConfigExpectation = self.expectation(description: "DealWatcher Init")
        client.onWatchCurrentDeal = { _ in watcherConfigExpectation.fulfill() }
        wait(for: [watcherConfigExpectation], timeout: 1)
        XCTAssertEqual(sut.dealState, ViewState<Deal>.loading)

        // START

        // `AppCoordinator.refreshDeal(for:)` sends .silentNotification (while `dealState` is `.loading`)
        sut.refreshDeal(for: .silentNotification(notification: notification, handler: handlerClosure))

        // ...

        // In-progress fetch completes
        let watcherResultExpectation = self.expectation(description: "dealState: .result")
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .filter { $0.isCompletion }
            .sink { if case .result = $0 { watcherResultExpectation.fulfill() } }
            .store(in: &cancellables)

        client.returnCurrentDealWatcherResponse(source: .server)
        wait(for: [watcherResultExpectation], timeout: 1)
        cancellables = .init()

        XCTAssert(ViewState<Deal>.prism.result.isCase(sut.dealState))

        wait(for: [fetchResultExpectation], timeout: 1)
        XCTAssertEqual(fetchResult, UIBackgroundFetchResult.newData)
    }

    func testSilentStatusNotificationWhileError() throws {
        // Prepare data
        let dealID: DealId = .currentDeal
        let launchStatus: LaunchStatus = .launchSoldOut
        let delta = makeStatusDelta(id: dealID, status: launchStatus)
        let notification: DealNotification = .delta(delta)

        client.configureWithFailure()
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations
        let currentDealRequestExpectation = self.expectation(description: "Called `fetchCurrentDeal()`")
        let currentDealResultExpectation = self.expectation(description: "Response returned from `fetchCurrentDeal()`")
        let fetchResultExpectation = self.expectation(description: "Backround fetch result handler called")
        var fetchResult: UIBackgroundFetchResult?

        client.onFetchCurrentDeal = { cachePolicy in
            currentDealRequestExpectation.fulfill()
            XCTAssertEqual(cachePolicy, CachePolicy.fetchIgnoringCacheData)
        }

        let handlerClosure: (UIBackgroundFetchResult) -> Void = { result in
            fetchResultExpectation.fulfill()
            fetchResult = result
        }

        // Standard startup
        let initExpectation = self.expectation(description: "Inital config finished")
        completeStandardSetup(initExpectation)
        wait(for: [initExpectation], timeout: 2)
        // Verify dataProvider is in expected initial state
        XCTAssert(ViewState<Deal>.prism.error.isCase(sut.dealState))
        try client.configureWithSuccess()

        // START

        // `AppCoordinator.refreshDeal(for:)` sends .silentNotification (while `dealState` is `.loading`)
        sut.refreshDeal(for: .silentNotification(notification: notification, handler: handlerClosure))

        // Since we can't apply `DealDelta` to `ViewState.error`, call
        // `fetchDealInBackground(dealID:fetchCompletionHandler:)`
        wait(for: [currentDealRequestExpectation], timeout: 1)

        // ... Server returns response

        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .filter { $0.isCompletion }
            .sink { if case .result = $0 { currentDealResultExpectation.fulfill() } }
            .store(in: &cancellables)

        client.returnFetchCurrentDealResponse()

        wait(for: [currentDealResultExpectation], timeout: 1)

        wait(for: [fetchResultExpectation], timeout: 1)
        XCTAssertEqual(fetchResult, UIBackgroundFetchResult.newData)
    }

    //func testSilentStatusNotificationWithDealMismatch() throws {}

    func testSilentNewNotification() throws {
        // Prepare data
        let dealID: DealId = .other
        let notification = makeNewNotification(id: dealID)

        // Notification would indicate a new deal differing from that in the cache
        try client.configureWithSuccess()
        client.currentDealResult = client.currentDealResult.map { Deal.lens.dealID.set(dealID.rawValue)($0!) }

        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Expectations
        let currentDealRequestExpectation = self.expectation(description: "Called `fetchCurrentDeal()`")
        let currentDealResultExpectation = self.expectation(description: "Response returned from `fetchCurrentDeal()`")
        let fetchResultExpectation = self.expectation(description: "Backround fetch result handler called")
        var fetchResult: UIBackgroundFetchResult?

        client.onFetchCurrentDeal = { cachePolicy in
            currentDealRequestExpectation.fulfill()
            XCTAssertEqual(cachePolicy, CachePolicy.fetchIgnoringCacheData)
        }

        let handlerClosure: (UIBackgroundFetchResult) -> Void = { result in
            fetchResultExpectation.fulfill()
            fetchResult = result
        }

        // Standard startup
        let initExpectation = self.expectation(description: "Inital config finished")
        completeStandardSetup(initExpectation)
        wait(for: [initExpectation], timeout: 2)
        // Verify dataProvider is in expected initial state
        let serverDeal = try client.dealWatcherResult.get()!
        XCTAssertEqual(sut.dealState, ViewState.result(serverDeal))
        XCTAssertEqual(sut.dealState.result!.dealID, DealId.currentDeal.rawValue)

        // START

        // `AppCoordinator.refreshDeal(for:)` sends .silentNotification
        sut.refreshDeal(for: .silentNotification(notification: notification, handler: handlerClosure))

        wait(for: [currentDealRequestExpectation], timeout: 1)

        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .filter { $0.isCompletion }
            .sink { if case .result = $0 { currentDealResultExpectation.fulfill() } }
            .store(in: &cancellables)

        client.returnFetchCurrentDealResponse()
        wait(for: [currentDealResultExpectation], timeout: 1)

        wait(for: [fetchResultExpectation], timeout: 1)
        XCTAssertEqual(fetchResult, UIBackgroundFetchResult.newData)
        XCTAssertEqual(sut.dealState.result!.dealID, dealID.rawValue)
    }

    // MARK: - RefreshEvent.foreground

    //func testForegroundWhenFresh() throws {}

    //func testForegroundWhenStale() throws {}

    //func testForegroundWithError() throws {}

    // MARK: - RefreshEvent.foregroundNotification

    //func testForegroundNotification() throws {}

    // MARK: - RefreshEvent.manual

    //func testManualRefresh() throws {}

    //func testManualRefreshWithError() throws {}

    // -----------------------------------------------------------------

    // - what happens if credentialsProvider is not ready

    // - what happens if currentDealWatcher is not ready

    // - what happens if there is a pendingRefreshEvent

    // what happens if dealState is .loading

}

// MARK: - Queries
extension DataProviderTests {

    // MARK: - Fetch Deal

    func testGetDealSuccess() throws {
        try client.configureWithSuccess()
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        let fulfillExpectation = self.expectation(description: "Returned result")
        let rejectExpectation = self.expectation(description: "Returned error")
        rejectExpectation.isInverted = true

        var result: GetDealQuery.Data.GetDeal?

        let dealID: DealId = .history
        sut.getDeal(withID: dealID.rawValue)
            .then { deal in
                fulfillExpectation.fulfill()
                result = deal
            }
            .catch { _ in
                rejectExpectation.fulfill()
            }

        client.returnFetchDealResponse()

        waitForExpectations(timeout: 1, handler: nil)

        let clientResult = try client.dealResult.get().getDeal
        XCTAssertEqual(result, clientResult)
    }

    func testGetDealFailure() throws {
        client.configureWithFailure()
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        let fulfillExpectation = self.expectation(description: "Returned result")
        fulfillExpectation.isInverted = true
        let rejectExpectation = self.expectation(description: "Returned error")

        let dealID: DealId = .history
        sut.getDeal(withID: dealID.rawValue)
            .then { deal in
                fulfillExpectation.fulfill()
            }
            .catch { _ in
                rejectExpectation.fulfill()
            }

        client.returnFetchDealResponse()

        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: - Fetch History

    func testGetDealHistorySuccess() throws {
        try client.configureWithSuccess()
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Initial historyState
        XCTAssertEqual(sut.historyState, ViewState<[DealHistoryQuery.Data.DealHistory.Item]>.empty)

        // Expectations
        let requestHistoryExpectation = self.expectation(description: "History Request")
        let historyLoadingExpectation = self.expectation(description: "historyState: .loading")
        let historyResultExpectation = self.expectation(description: "historyState: .result")

        var historyResult: [DealHistoryQuery.Data.DealHistory.Item]?
        sut.$historyState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .sink { historyState in
                switch historyState {
                case .loading:
                    historyLoadingExpectation.fulfill()
                case .result(let result):
                    historyResultExpectation.fulfill()
                    historyResult = result
                case .empty:
                    XCTFail("Unexpected .empty historyState")
                case .error(let error):
                    XCTFail("Unexpected .error historyState: \(error)")
                }
            }
            .store(in: &cancellables)

        client.onFetchDealHistory = { _, _, _ in
            requestHistoryExpectation.fulfill()
        }

        sut.getDealHistory()

        //XCTAssertEqual(sut.historyState, ViewState<[DealHistoryQuery.Data.DealHistory.Item]>.loading)
        wait(for: [requestHistoryExpectation, historyLoadingExpectation], timeout: 2)

        // Client returns `DealHistory`
        client.returnFetchDealHistoryResponse()

        waitForExpectations(timeout: 2, handler: nil)

        let clientHistoryResult = try client.historyResult.get().dealHistory?.items?.compactMap { $0 }
        XCTAssertEqual(historyResult, clientHistoryResult)
    }

    func testGetDealHistoryFailure() throws {
        client.configureWithFailure()
        sut = DataProvider(credentialsProvider: credentialsProvider, client: client)

        // Initial historyState
        XCTAssertEqual(sut.historyState, ViewState<[DealHistoryQuery.Data.DealHistory.Item]>.empty)

        // Expectations
        let requestHistoryExpectation = self.expectation(description: "History Request")
        let historyLoadingExpectation = self.expectation(description: "historyState: .loading")
        let historyResultExpectation = self.expectation(description: "historyState: .result")
        let historyErrorExpectation = self.expectation(description: "historyState: .error")
        historyResultExpectation.isInverted = true

        sut.$historyState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .sink { historyState in
                switch historyState {
                case .loading:
                    historyLoadingExpectation.fulfill()
                case .result:
                    historyResultExpectation.fulfill()
                case .empty:
                    XCTFail("Unexpected .empty historyState")
                case .error:
                    historyErrorExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        client.onFetchDealHistory = { _, _, _ in
            requestHistoryExpectation.fulfill()
        }

        sut.getDealHistory()

        //XCTAssertEqual(sut.historyState, ViewState<[DealHistoryQuery.Data.DealHistory.Item]>.loading)
        wait(for: [requestHistoryExpectation, historyLoadingExpectation], timeout: 2)

        // Client returns `DealHistory`
        client.returnFetchDealHistoryResponse()

        waitForExpectations(timeout: 2, handler: nil)
    }

}

// MARK: - Helpers
extension DataProviderTests {

    enum DealId: String {
        case currentDeal = "a6k5A000000bzmBQAQ"
        case history = "a6k5A000000kSimQAE"
        case other = "zzzzzzzzzzzzzzzzzz"
    }

    // MARK: - Delta

    func makeCommentDelta(id dealID: DealId = .currentDeal, count commentCount: Int = 25) -> DealDelta {
        let deltaType = DealDelta.DeltaType.commentCount(commentCount)
        return DealDelta(dealID: dealID.rawValue, deltaType: deltaType)
    }

    func makeStatusDelta(
        id dealID: DealId = .currentDeal,
        status launchStatus: LaunchStatus = .launchSoldOut
    ) -> DealDelta {
        let deltaType = DealDelta.DeltaType.launchStatus(launchStatus)
        return DealDelta(dealID: dealID.rawValue, deltaType: deltaType)
    }

    // MARK: - Notification

    func makeNewNotification(id dealID: DealId = .currentDeal) -> DealNotification {
        return DealNotification.new(dealID.rawValue)
    }

    func makeCommentNotification(
        id dealID: DealId = .currentDeal,
        count commentCount: Int = 25
    ) -> DealNotification {
        let delta = makeCommentDelta(id: dealID, count: commentCount)
        return DealNotification.delta(delta)
    }

    func makeStatusNotification(
        id dealID: DealId = .currentDeal,
        status launchStatus: LaunchStatus = .launchSoldOut
    ) -> DealNotification {
        let delta = makeStatusDelta(id: dealID, status: launchStatus)
        return DealNotification.delta(delta)
    }

    // MARK: - Standard Launch Configuration

    func completeStandardSetup(_ expectation: XCTestExpectation) {
        sut.refreshDeal(for: .launch)
        credentialsProvider.completeInit()

        // FIXME: this seems neddlessly complicated
        let watcherConfigExpectation = self.expectation(description: "DealWatcher Init")
        let watcherResultExpectation = self.expectation(description: "dealState: .result")
        client.onWatchCurrentDeal = { _ in watcherConfigExpectation.fulfill() }
        sut.$dealState
            .receive(on: DispatchQueue.main)
            .dropFirst() // Ignore initial .empty
            .filter { $0.isCompletion }
            .sink { _ in watcherResultExpectation.fulfill() }
            //.sink { if case .result = $0 { watcherResultExpectation.fulfill() } }
            .store(in: &cancellables)

        wait(for: [watcherConfigExpectation], timeout: 1)
        client.returnCurrentDealWatcherResponse(source: .server)
        wait(for: [watcherResultExpectation], timeout: 1)

        cancellables = .init()
        expectation.fulfill()
    }

}



// MARK: - refreshDeal(for:)
/*
enum RefreshEvent {
    /// Application did finish launching.
    case launch
    /// Application did finish launching from notification.
    case launchFromNotification(DealDelta)
    /// Application will enter foreground.
    case foreground
    // TODO: add case for coming back online?
    /// Application received foreground notification.
    case foregroundNotification

    /// Application received silent notification.
    case silentNotification((UIBackgroundFetchResult) -> Void)
    //case silentNotification(notification: DealDelta, handler: (UIBackgroundFetchResult) -> Void)
    /// Manual refresh.
    case manual
}
*/
