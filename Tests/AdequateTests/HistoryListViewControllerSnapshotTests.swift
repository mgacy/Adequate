//
//  HistoryListViewControllerSnapshotTests.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/19/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Adequate

// swiftlint:disable type_name
class HistoryListViewControllerSnapshotTests: SnapshotTestBase {

    override func makeSUT() throws -> UIViewController {
        let vc = UINavigationController(rootViewController: HistoryListViewController(dependencies: dependencies))
        let rootPageViewController = RootPageViewController(dependencies: dependencies)
        rootPageViewController.setPages([vc], displayIndex: 0, animated: false)
        return rootPageViewController
    }

    func renderResult() throws {
        let history = try loadHistoryListData()
        //let history = try DealLoader.loadHistoryList()
        dataProvider.historyState = .result(history)
    }
}

// MARK: - iPhone
extension HistoryListViewControllerSnapshotTests {

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

// MARK: - iPad Pro (10.5) - Landscape
extension HistoryListViewControllerSnapshotTests {

    func test_iPadPro10_5_landscape_oneThird() throws {
        sut = try makeSUT()
        try renderResult()

        let orientation = ViewImageConfig.TabletOrientation.landscape(splitView: .oneThird)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }

    func test_iPadPro10_5_landscape_twoThirds() throws {
        sut = try makeSUT()
        try renderResult()

        let orientation = ViewImageConfig.TabletOrientation.landscape(splitView: .twoThirds)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }

    func test_iPadPro10_5_landscape_full() throws {
        sut = try makeSUT()
        try renderResult()

        let orientation = ViewImageConfig.TabletOrientation.landscape(splitView: .full)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }
}

// MARK: - iPad Pro (10.5) - Portrait
extension HistoryListViewControllerSnapshotTests {

    func test_iPadPro10_5_portrait_oneThird() throws {
        sut = try makeSUT()
        try renderResult()

        let orientation = ViewImageConfig.TabletOrientation.portrait(splitView: .oneThird)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }

    func test_iPadPro10_5_portrait_twoThirds() throws {
        sut = try makeSUT()
        try renderResult()

        let orientation = ViewImageConfig.TabletOrientation.portrait(splitView: .twoThirds)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }

    func test_iPadPro10_5_portrait_full() throws {
        sut = try makeSUT()
        try renderResult()

        let orientation = ViewImageConfig.TabletOrientation.portrait(splitView: .full)
        let config = ViewImageConfig.iPadPro10_5(orientation)
        assertSnapshot(matching: sut, as: .image(on: config), record: shouldRecord)
    }
}
