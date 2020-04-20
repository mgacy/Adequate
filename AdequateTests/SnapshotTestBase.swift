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

    enum ResponseResource: String {
        case currentDeal
        case historyList
        case historyDetail
    }

    // TODO: return JSONObject rather than Data?
    func loadJSON(from resource: ResponseResource) throws -> Data {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: resource.rawValue, ofType: "json")
        return try Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    }

    func loadCurrentDealData() throws -> Deal {
        let jsonData = try loadJSON(from: .currentDeal)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [.mutableContainers]) as! JSONObject
        let getDeal = try GetDealQuery.Data.GetDeal(jsonObject: jsonObject)
        guard let deal = Deal(getDeal) else {
            throw SyncClientError.missingData(data: getDeal)
        }
        return deal
    }

    func loadHistoryDetailData() throws -> GetDealQuery.Data.GetDeal {
        let jsonData = try loadJSON(from: .historyDetail)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [.mutableContainers]) as! JSONObject
        return try GetDealQuery.Data.GetDeal(jsonObject: jsonObject)
    }

    typealias DealHistory = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    func loadHistoryListData() throws -> [DealHistory] {
        let jsonData = try loadJSON(from: .historyList)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [.mutableContainers]) as! [JSONObject]
        return jsonObject.compactMap { try? DealHistory(jsonObject: $0) }
    }
}
