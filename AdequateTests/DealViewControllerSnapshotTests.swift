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

class DealViewControllerSnapshotTests: SnapshotTestBase {

    override func makeSUT() throws -> UIViewController {
        let vc = UINavigationController(rootViewController: DealViewController(dependencies: dependencies))
        let rootPageViewController = RootPageViewControler(depenedencies: dependencies)
        rootPageViewController.setPages([vc], displayIndex: 0, animated: false)

        let deal = try loadCurrentDealData()
        dataProvider.dealState = .result(deal)

        return rootPageViewController
    }
}

// MARK: - iPhone
extension DealViewControllerSnapshotTests {

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
