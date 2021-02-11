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
        case .unknown: return .label
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

// MARK: - GetDealQuery + Equatable

extension GetDealQuery.Data.GetDeal: Equatable {

    public static func == (lhs: GetDealQuery.Data.GetDeal, rhs: GetDealQuery.Data.GetDeal) -> Bool {
        return lhs.id == rhs.id
        && lhs.dealId == rhs.dealId
        && lhs.dealYear == rhs.dealYear
        && lhs.monthDay == rhs.monthDay
        && lhs.title == rhs.title
        && lhs.features == rhs.features
        && lhs.specifications == rhs.specifications
        && lhs.url == rhs.url
        && lhs.createdAt == rhs.createdAt
        && lhs.endDate == rhs.endDate
        && lhs.soldOutAt == rhs.soldOutAt
        && lhs.items == rhs.items
        && lhs.modelNumbers == rhs.modelNumbers
        && lhs.photos == rhs.photos
        && lhs.story == rhs.story
        && lhs.topic == rhs.topic
        && lhs.theme == rhs.theme
        && lhs.purchaseQuantity == rhs.purchaseQuantity
        && lhs.launches == rhs.launches
        // Accessing `.launchStatus` fails due to error force casting as `LaunchStatus`
        // swiftlint:disable:next force_cast
        && lhs.snapshot["launchStatus"]! as! String == rhs.snapshot["launchStatus"]! as! String
        && lhs.version == rhs.version
        && lhs.deleted == rhs.deleted
        && lhs.lastChangedAt == rhs.lastChangedAt
        && lhs.updatedAt == rhs.updatedAt
    }
}

extension GetDealQuery.Data.GetDeal.Item: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
        //&& lhs.condition == rhs.condition
        //&& lhs.photo == rhs.photo
        //&& lhs.price == rhs.price
    }
}

extension GetDealQuery.Data.GetDeal.Launch: Equatable {
     public static func == (lhs: Self, rhs: Self) -> Bool {
         lhs.soldOutAt == rhs.soldOutAt
     }
 }

extension GetDealQuery.Data.GetDeal.PurchaseQuantity: Equatable {
     public static func == (lhs: Self, rhs: Self) -> Bool {
         return lhs.maximumLimit == rhs.maximumLimit
             && lhs.minimumLimit == rhs.minimumLimit
     }
 }

extension GetDealQuery.Data.GetDeal.Story: Equatable {
     public static func == (lhs: Self, rhs: Self) -> Bool {
         return lhs.title == rhs.title
             && lhs.body == rhs.body
     }
 }

extension GetDealQuery.Data.GetDeal.Theme: Equatable {
     public static func == (lhs: Self, rhs: Self) -> Bool {
         return lhs.accentColor == rhs.accentColor
             && lhs.backgroundColor == rhs.backgroundColor
            // Accessing `.foreground` fails due to error force casting as `ThemeForeground`
            // swiftlint:disable:next force_cast
            && lhs.snapshot["foreground"]! as! String == rhs.snapshot["foreground"]! as! String
     }
 }

extension GetDealQuery.Data.GetDeal.Topic: Equatable {
     public static func == (lhs: Self, rhs: Self) -> Bool {
         return lhs.id == rhs.id
             && lhs.commentCount == rhs.commentCount
             && lhs.createdAt == rhs.createdAt
             //&& lhs.replyCount == rhs.replyCount
             && lhs.url == rhs.url
             //&& lhs.voteCount == rhs.voteCount
     }
 }

// MARK: - DealHistoryQuery + Model Protocols

extension DealHistoryQuery.Data.DealHistory.Item.Item: ItemType {}

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

// MARK: - DealHistoryQuery + Hashable

extension DealHistoryQuery.Data.DealHistory.Item: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
