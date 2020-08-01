//
//  MehSyncClientTests.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 7/29/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import XCTest
@testable import Adequate
import AWSAppSync
import AWSMobileClient

class MehSyncClientTests: XCTestCase {

    // TODO: mock `AWSAppSyncClient`
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - A

    func testFetchDeal_NilResponse() throws {
        let credentialsProvider = AWSMobileClient.default()
        let client = MehSyncClient(credentialsProvider: credentialsProvider)

        // Initialize credentialsProvider and make request
        let userStatePromise = expectation(description: "Initialize AWSMobileClient")
        let queryPromise = expectation(description: "Fetch Result")
        credentialsProvider.initialize()
            .then { userState in
                userStatePromise.fulfill()
                XCTAssertEqual(userState, UserState.guest, "Unexpected UserState")

                let query = GetDealQuery(id: "null_query")
                let cachePolicy = CachePolicy.fetchIgnoringCacheData
                let cancellable = client.fetchDeal(query: query, cachePolicy: cachePolicy) { result in
                    queryPromise.fulfill()

                    switch result {
                    case .success(let maybeDeal):
                        XCTAssertEqual(maybeDeal, nil, "Unexpected data result")
                    case .failure(let error):
                        XCTFail("Error: \(error.localizedDescription)")
                    }
                }
        }.catch { error in
            XCTFail("Error: \(error.localizedDescription)")
        }

        wait(for: [userStatePromise, queryPromise], timeout: 10)
    }

}
