//
//  SnapshotTestBase.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/19/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import XCTest
import AWSAppSync
@testable import Adequate

// NOTE: all snapshots were generated using iPad Pro (10.5-inch)
class SnapshotTestBase: XCTestCase {

    var dataProvider: DataProviderMock!
    var imageService: ImageServiceMock!
    var themeManager: ThemeManagerMock!
    var dependencies: AppDependencyMock!

    var sut: UIViewController!

    var shouldRecord: Bool = false

    // MARK: - Configuration

    override func setUpWithError() throws {
        dataProvider = DataProviderMock()
        imageService = ImageServiceMock()
        themeManager = ThemeManagerMock(theme: .system)
        dependencies = AppDependencyMock(dataProvider: dataProvider, imageService: imageService, themeManager: themeManager)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        dataProvider = nil
        imageService = nil
        themeManager = nil
        dependencies = nil
        sut = nil
        try super.tearDownWithError()
    }

    func makeSUT() throws -> UIViewController {
        fatalError("Override method")
    }
}

// MARK: - Factory Methods
extension SnapshotTestBase {

    func getSnapshot(named snapshotName: String, from jsonObject: JSONObject) -> JSONValue {
        let data = jsonObject["data"] as! JSONObject
        return data[snapshotName]!
    }

    func loadCurrentDealData() throws -> Deal {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.currentDeal,
                                                 in: Bundle(for: type(of: self)))
        let snapshot = getSnapshot(named: "getDeal", from: jsonObject) as! JSONObject
        let getDeal = try GetDealQuery.Data.GetDeal(jsonObject: snapshot)
        guard let deal = Deal(getDeal) else {
            throw SyncClientError.missingData(data: getDeal)
        }
        return deal
    }

    func loadHistoryDetailData() throws -> GetDealQuery.Data.GetDeal {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyDetail,
                                                 in: Bundle(for: type(of: self)))
        let snapshot = getSnapshot(named: "getDeal", from: jsonObject) as! JSONObject
        return try GetDealQuery.Data.GetDeal(jsonObject: snapshot)
    }

    typealias DealHistory = DealHistoryQuery.Data.DealHistory

    func loadHistoryListData() throws -> [DealHistory.Item] {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyList,
                                                 in: Bundle(for: type(of: self)))
        let snapshot = getSnapshot(named: "dealHistory", from: jsonObject) as! JSONObject
        let history = try DealHistory(jsonObject: snapshot)
        return history.items?.compactMap { $0 } ?? []
    }
}
