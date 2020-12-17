//
//  DeepLink.swift
//  Adequate
//
//  https://github.com/imaccallum/CoordinatorKit
//

import UIKit.UIApplication
import UserNotifications

enum DeepLink {
    /// Show onboarding scene.
    case onboarding
    /// Respond to launch from remote notification.
    case remoteNotification(DealNotification)
    /// Show current deal scene.
    case deal
    /// Show purchase page for current deal.
    case buy(URL)
    /// Show share sheet from current deal scene.
    case share(title: String, url: URL)
    /// Show debug view.
    case debug
    // TODO: add case to allow widget to add a reminder for relaunch / reserve
}

// MARK: - Builders
extension DeepLink {

    static func build(with dict: [String: AnyObject]?) -> DeepLink? {
        guard let id = dict?["launch_id"] as? String else { return nil }

        switch id {
        case DeepLinkURLConstants.onboarding: return .onboarding
        default: return nil
        }
    }

    static func build(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> DeepLink? {
        guard let notification = launchOptions?[.remoteNotification] as? [String: AnyObject],
              let dealNotification = DealNotification(userInfo: notification) else {
            return nil
        }
        return .remoteNotification(dealNotification)
    }

    static func build(with url: URL) -> DeepLink? {
        switch url.host {
        case DeepLinkURLConstants.deal: return .deal
        default: return nil
        }
    }

    static func build(with userActivity: NSUserActivity) -> DeepLink? {
        return nil
    }

    static func build(with notificationResponse: UNNotificationResponse) -> DeepLink? {
        let userInfo = notificationResponse.notification.request.content.userInfo
        switch notificationResponse.notification.request.content.categoryIdentifier {

        // dailyDeal
        case NotificationCategoryIdentifier.dailyDeal.rawValue:
            switch notificationResponse.actionIdentifier {
            case NotificationAction.buyAction.rawValue:
                guard
                    let urlString = userInfo[NotificationPayloadKey.dealURL] as? String,
                    let buyURL = URL(string: urlString) else {
                        log.error("ERROR: unable to parse \(NotificationPayloadKey.dealURL) from Notification")
                        return nil
                }
                return .buy(buyURL)
            case NotificationAction.shareAction.rawValue:
                guard
                    let urlString = userInfo[NotificationPayloadKey.dealURL] as? String,
                    let dealURL = URL(string: urlString)?.deletingLastPathComponent() else {
                        log.error("ERROR: unable to parse \(NotificationPayloadKey.dealURL) from Notification")
                        return nil
                }
                let title = notificationResponse.notification.request.content.body
                return .share(title: title, url: dealURL)
            case UNNotificationDefaultActionIdentifier:
                log.info("\(#function) - DefaultActionIdentifier")
                return deal
            case UNNotificationDismissActionIdentifier:
                // TODO: how to handle?
                log.info("\(#function) - DismissActionIdentifier")
                return nil
            default:
                log.warning("\(#function) - unknown action: \(notificationResponse.actionIdentifier)")
                return nil
            }
        default:
            let categoryID = notificationResponse.notification.request.content.categoryIdentifier
            log.warning("\(#function) - unknown category: \(categoryID)")
            return nil
        }
    }

}

// MARK: - Constants
extension DeepLink {
    struct DeepLinkURLConstants {
        static let deal = "deal"
        static let onboarding = "onboarding"
    }
}
