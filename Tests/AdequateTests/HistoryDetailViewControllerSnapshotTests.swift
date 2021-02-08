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

// swiftlint:disable type_name
class HistoryDetailViewControllerSnapshotTests: SnapshotTestBase {

    override func makeSUT() throws -> UIViewController {
        let historyList = try loadHistoryListData()
        //let historyList = try DealLoader.loadHistoryList()
        dataProvider.historyState = .result(historyList)

        let historyDetail = try loadHistoryDetailData()
        //let historyDetail = try DealLoader.loadHistoryDetail()
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
        sut = try makeSUT()

        let config = ViewImageConfig.iPhone8
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }

    func test_iPhoneX() throws {
        sut = try makeSUT()

        let config = ViewImageConfig.iPhoneX
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }
}
