//
//  HistoryDetailViewControllerSnapshotTests.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/19/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Adequate

class HistoryDetailViewControllerSnapshotTests: SnapshotTestBase {
    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    override func makeSUT() throws -> UIViewController {
        let historyList = try loadHistoryListData()
        dataProvider.historyState = .result(historyList)

        let historyDetail = try loadHistoryDetailData()
        dataProvider.dealResponse = .success(historyDetail)

        let dealFragment = historyList[0]
        let detailVC = HistoryDetailViewController(dependencies: dependencies, deal: dealFragment)
        let vc = UINavigationController(rootViewController: detailVC)

        detailVC.loadViewIfNeeded()
        detailVC.render(.result(historyDetail))

        return vc
    }
}

// MARK: - iPhone
extension HistoryDetailViewControllerSnapshotTests {

    func test_iPhone8() throws {
        record = shouldRecord
        sut = try makeSUT()

        let config = ViewImageConfig.iPhone8
        assertSnapshot(matching: sut, as: .image(on: config))
    }

    func test_iPhoneX() throws {
        record = shouldRecord
        sut = try makeSUT()

        let config = ViewImageConfig.iPhoneX
        assertSnapshot(matching: sut, as: .image(on: config))
    }
}
