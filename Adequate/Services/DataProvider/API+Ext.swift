//
//  API+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

extension LaunchStatus: Codable {}

extension ThemeForeground: Codable {

    var textColor: UIColor {
        switch self {
        case .dark: return .black
        case .light: return .white
        case .unknown: return ColorCompatibility.label
        }
    }

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark:
            return .darkContent
        case .light: return .lightContent
        case .unknown: return .default
        }
    }

    var navigationBarStyle: UIBarStyle {
        switch self {
        case .dark: return .default
        case .light: return .black
        case .unknown: return .default
        }
    }

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .dark: return .light
        case .light: return .dark
        case .unknown: return .unspecified
        }
    }

}

extension ThemeForeground {

    init(userInterfaceStyle: UIUserInterfaceStyle) {
        switch userInterfaceStyle {
        case .light:
            self = .dark
        case .dark:
            self = .light
        case .unspecified:
            self = .unknown("system")
        @unknown default:
            self = .unknown("unknown")
        }
    }
}

// MARK: - GetDealQuery + Model Protocols

extension GetDealQuery.Data.GetDeal.Item: ItemType {}

extension GetDealQuery.Data.GetDeal.Launch: LaunchType {}

extension GetDealQuery.Data.GetDeal.PurchaseQuantity: PurchaseQuantityType {}

extension GetDealQuery.Data.GetDeal.Story: StoryType {}

extension GetDealQuery.Data.GetDeal.Theme: ThemeType {}

extension GetDealQuery.Data.GetDeal.Topic: TopicType {}

// MARK: - DealHistoryQuery + Model Protocols

extension DealHistoryQuery.Data.DealHistory.Item.Theme: ThemeType {}

// MARK: - DealHistoryQuery + Equatable

extension DealHistoryQuery.Data.DealHistory.Item.Theme: Equatable {
    public static func == (lhs: DealHistoryQuery.Data.DealHistory.Item.Theme, rhs: DealHistoryQuery.Data.DealHistory.Item.Theme) -> Bool {
        return lhs.accentColor == rhs.accentColor
            && lhs.backgroundColor == rhs.backgroundColor
            && lhs.foreground == rhs.foreground
    }
}

extension DealHistoryQuery.Data.DealHistory.Item.Item: Equatable {
    public static func == (lhs: DealHistoryQuery.Data.DealHistory.Item.Item, rhs: DealHistoryQuery.Data.DealHistory.Item.Item) -> Bool {
        return lhs.id == rhs.id
            //&& lhs.condition == rhs.condition
            //&& lhs.photo == rhs.photo
            //&& lhs.price == rhs.price
    }
}

extension DealHistoryQuery.Data.DealHistory.Item: Equatable {
    public static func == (lhs: DealHistoryQuery.Data.DealHistory.Item, rhs: DealHistoryQuery.Data.DealHistory.Item) -> Bool {
        return lhs.id == rhs.id
            //&& lhs.title == rhs.title
            //&& lhs.createdAt == rhs.createdAt
            //&& lhs.dealYear == rhs.dealYear
            //&& lhs.monthDay == rhs.monthDay
            //&& lhs.items == rhs.items
            //&& lhs.photos == rhs.photos
            //&& lhs.theme == rhs.theme
    }
}
