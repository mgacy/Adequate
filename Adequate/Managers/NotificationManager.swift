//
//  NotificationManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UserNotifications
import Promise

// MARK: - Protocol

protocol NotificationManagerType {
    func requestAuthorization() -> Promise<Bool>
    func registerForPushNotifications() -> Promise<Void>
    func unregisterForRemoteNotifications()
}

// MARK: - Errors

enum NotificationManagerError: Error {
    case unauthorized
    case general(message: String)
}

// MARK: - Configuration

/// TODO: Rename NotificationCategory to mirror NotificationAction?
fileprivate enum CategoryIdentifier: String {
    case dailyDeal = "MGDailyDealCategory"
}

enum NotificationAction: String {
    case buyAction = "MGBuyAction"
    case mehAction = "MGMehAction"

    /// TODO: what about localization?
    var title: String {
        switch self {
        case .buyAction:
            return "Buy"
        case .mehAction:
            return "Meh"
        }
    }
}

struct NotificationConstants {
    static let dealKey = "adequate-deal-url"
    static let imageKey = "adequate-image-url"
}

// MARK: - Implementation

class NotificationManager: NSObject, NotificationManagerType {

    private let notificationCenter: UNUserNotificationCenter

    override init() {
        self.notificationCenter = .current()
        super.init()
    }

    // MARK: - NotificationManagerType

    func requestAuthorization() -> Promise<Bool> {
        let options: UNAuthorizationOptions = [.alert, .sound]
        return notificationCenter.requestAuthorization(options: options)
    }

    func registerForPushNotifications() -> Promise<Void> {
        return requestAuthorization()
            .ensure({ $0 })
            .then(on: DispatchQueue.global(), { _ in
                self.notificationCenter.setNotificationCategories([self.makeCategory(for: .dailyDeal)])
            })
            .then({ settings in
                /// must register on main thread
                UIApplication.shared.registerForRemoteNotifications()
            })
    }

    func unregisterForRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    // MARK: - Helper Factory Methods

    private func makeCategory(for categoryID: CategoryIdentifier) -> UNNotificationCategory {
        let actions = makeActions(for: categoryID)
        return UNNotificationCategory(identifier: categoryID.rawValue,
                                      actions: actions, intentIdentifiers: [], options: [])
    }

    private func makeActions(for categoryID: CategoryIdentifier) -> [UNNotificationAction] {
        let actions: [UNNotificationAction]
        switch categoryID {
        case .dailyDeal:
            let buyAction = UNNotificationAction(identifier: NotificationAction.buyAction.rawValue,
                                                 title: NotificationAction.buyAction.title, options: [.foreground])
            //let viewAction = ...
            let mehAction = UNNotificationAction(identifier: NotificationAction.mehAction.rawValue,
                                                 title: NotificationAction.mehAction.title, options: [.foreground])
            actions = [buyAction, mehAction]
        }
        return actions
    }

}
