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

    func loadCurrentDealData() throws -> Deal {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.currentDeal,
                                                 in: Bundle(for: type(of: self)))
        let getDeal = try GetDealQuery.Data.GetDeal(jsonObject: jsonObject)
        guard let deal = Deal(getDeal) else {
            throw SyncClientError.missingData(data: getDeal)
        }
        return deal
    }

    func loadHistoryDetailData() throws -> GetDealQuery.Data.GetDeal {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyDetail,
                                                 in: Bundle(for: type(of: self)))
        return try GetDealQuery.Data.GetDeal(jsonObject: jsonObject)
    }

    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    func loadHistoryListData() throws -> [DealHistory] {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyList,
                                                 in: Bundle(for: type(of: self)))
        return jsonObject.compactMap { try? DealHistory(jsonObject: $0) }
    }
}
