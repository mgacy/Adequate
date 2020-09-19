//
//  PadHistoryDetailViewControllerSnapshotTests.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/19/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Adequate

class PadHistoryDetailViewControllerSnapshotTests: SnapshotTestBase {

    override func makeSUT() throws -> UIViewController {
        let historyList = try loadHistoryListData()
        dataProvider.historyState = .result(historyList)

        let historyDetail = try loadHistoryDetailData()
        dataProvider.dealResponse = .success(historyDetail)

        let dealFragment = historyList[0]
        let detailVC = PadHistoryDetailViewController(dependencies: dependencies, deal: dealFragment)
        let vc = UINavigationController(rootViewController: detailVC)

        detailVC.loadViewIfNeeded()
        detailVC.render(.result(historyDetail))

        return vc
    }
}

// MARK: - iPad Pro (10.5) - Landscape
extension PadHistoryDetailViewControllerSnapshotTests {

    func test_iPadPro10_5_landscape_oneThird() throws {
        isRecording = shouldRecord
        sut = try makeSUT()

        let orientation = ViewImageConfig.TabletOrientation.landscape(splitView: .oneThird)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config))
    }

    func test_iPadPro10_5_landscape_twoThirds() throws {
        isRecording = shouldRecord
        sut = try makeSUT()

        let orientation = ViewImageConfig.TabletOrientation.landscape(splitView: .twoThirds)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config))
    }

    func test_iPadPro10_5_landscape_full() throws {
        isRecording = shouldRecord
        sut = try makeSUT()

        let orientation = ViewImageConfig.TabletOrientation.landscape(splitView: .full)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config))
    }
}

// MARK: - iPad Pro (10.5) - Portrait
extension PadHistoryDetailViewControllerSnapshotTests {

    func test_iPadPro10_5_portrait_oneThird() throws {
        isRecording = shouldRecord
        sut = try makeSUT()

        let orientation = ViewImageConfig.TabletOrientation.portrait(splitView: .oneThird)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config))
    }

    func test_iPadPro10_5_portrait_twoThirds() throws {
        isRecording = shouldRecord
        sut = try makeSUT()

        let orientation = ViewImageConfig.TabletOrientation.portrait(splitView: .twoThirds)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config))
    }

    func test_iPadPro10_5_portrait_full() throws {
        isRecording = shouldRecord
        sut = try makeSUT()

        let orientation = ViewImageConfig.TabletOrientation.portrait(splitView: .full)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config))
    }
}
