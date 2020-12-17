//
//  NotificationCategoryIdentifier+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/5/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UserNotifications

// MARK: - NotificationCategoryIdentifier + Ext
extension NotificationCategoryIdentifier {

    /// The actions to display when a notification of this type is presented.
    var actions: [NotificationAction] {
        switch self {
        case .dailyDeal:
            return [.buyAction, .shareAction]
        }
    }

    /// The intents related to notifications of this category.
    var intentIdentifiers: [String] {
        switch self {
        case .dailyDeal:
            return []
        }
    }

    /// Options for how to handle notifications of this type.
    var options: UNNotificationCategoryOptions {
        switch self {
        case .dailyDeal:
            return []
        }
    }
}

/// Actions to display when a notification is presented.
enum NotificationAction: String {
    case buyAction = "MGBuyAction"
    //case mehAction = "MGMehAction"
    case shareAction = "MGShareAction"

    var title: String {
        switch self {
        case .buyAction:
            return L10n.buy
        //case .mehAction:
        //    return L10n.meh
        case .shareAction:
            return L10n.share
        }
    }

    var options: UNNotificationActionOptions {
        switch self {
        case .buyAction:
            return [.foreground]
        case .shareAction:
            return [.foreground]
        }
    }
}
