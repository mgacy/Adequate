//
//  DealLoader.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/6/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import AWSAppSync
@testable import Adequate

// swiftlint:disable force_cast
final class DealLoader {

    static func loadCurrentDealData() throws -> GetDealQuery.Data.GetDeal {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.currentDeal, in: Bundle(for: self))
        let snapshot = Self.getSnapshot(named: "getDeal", from: jsonObject) as! JSONObject
        let getDeal = try GetDealQuery.Data.GetDeal(jsonObject: snapshot)
        return getDeal
    }

    static func loadCurrentDeal() throws -> Deal {
        let getDeal = try Self.loadCurrentDealData()
        guard let deal = Deal(getDeal) else {
            throw SyncClientError.missingField(selectionSet: getDeal)
        }
        return deal
    }

    static func loadHistoryDetailData() throws -> GetDealQuery.Data {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyDetail, in: Bundle(for: self))
        let snapshot = jsonObject["data"] as! JSONObject
        return GetDealQuery.Data(snapshot: snapshot)
    }

    static func loadHistoryDetail() throws -> GetDealQuery.Data.GetDeal {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyDetail, in: Bundle(for: self))
        let snapshot = Self.getSnapshot(named: "getDeal", from: jsonObject) as! JSONObject
        return try GetDealQuery.Data.GetDeal(jsonObject: snapshot)
    }

    static func loadHistoryListData() throws -> DealHistoryQuery.Data {
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyList, in: Bundle(for: self))
        let snapshot = jsonObject["data"] as! JSONObject
        return DealHistoryQuery.Data(snapshot: snapshot)
    }

    typealias DealHistory = DealHistoryQuery.Data.DealHistory

    static func loadHistoryList() throws -> [DealHistory.Item] {
        //let historyData = try Self.loadHistoryListData()
        //return historyData.dealHistory?.items?.compactMap { $0 } ?? []
        let jsonObject = try FileLoader.loadJSON(from: ResponseResource.historyList, in: Bundle(for: self))
        let snapshot = getSnapshot(named: "dealHistory", from: jsonObject) as! JSONObject
        let history = try DealHistory(jsonObject: snapshot)
        return history.items?.compactMap { $0 } ?? []
    }

    // MARK: - Private

    // Snapshot = [String: Any?]
    // JSONObject = [String: JSONValue] = [String: Any]
    static private func getSnapshot(named snapshotName: String, from jsonObject: JSONObject) -> JSONValue {
        let data = jsonObject["data"] as! JSONObject
        return data[snapshotName]!
    }
}
