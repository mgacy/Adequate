//
//  DealViewControllerSnapshotTests.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/19/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Adequate

// NOTE: all snapshots were generated using iPad Pro (10.5-inch)
class DealViewControllerSnapshotTests: SnapshotTestBase {

    override func makeSUT() throws -> UIViewController {
        let vc = UINavigationController(rootViewController: DealViewController(dependencies: dependencies))
        let rootPageViewController = RootPageViewControler(depenedencies: dependencies)
        rootPageViewController.setPages([vc], displayIndex: 0, animated: false)
        return rootPageViewController
    }

    func renderResult() throws {
        let deal = try loadCurrentDealData()
        dataProvider.dealState = .result(deal)
    }
}

// MARK: - iPhone
extension DealViewControllerSnapshotTests {

    func test_iPhone8() throws {
        sut = try makeSUT()
        try renderResult()

        let config = ViewImageConfig.iPhone8
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }

    func test_iPhoneX() throws {
        sut = try makeSUT()
        try renderResult()

        let config = ViewImageConfig.iPhoneX
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }
}
