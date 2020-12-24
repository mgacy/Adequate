//
//  NotificationManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UserNotifications
import Promise

// MARK: - Errors

enum NotificationManagerError: Error {
    case unauthorized
    case general(message: String)
}

class NotificationManager: NSObject, NotificationManagerType {

    private let notificationCenter: UNUserNotificationCenter
    //private let requestedNotificationOptions: UNAuthorizationOptions = [.alert, .sound]

    override init() {
        self.notificationCenter = .current()
        super.init()
    }

    // MARK: - NotificationManagerType

    /// Returns the notification authorization status for this app.
    func isAuthorized() -> Promise<Bool> {
        return notificationCenter.getNotificationSettings().then({ settings -> Bool in
            switch settings.authorizationStatus {
            case .authorized:
                return true
            default:
                return false
            }
        })
    }

    /// Request authorization to interact with the user when local and remote notifications are delivered to their
    /// device.
    func requestAuthorization() -> Promise<Bool> {
        let options: UNAuthorizationOptions = [.alert, .sound]
        return notificationCenter.requestAuthorization(options: options)
    }

    /// Register to receive remote notifications via Apple Push Notification service.
    func registerForPushNotifications() -> Promise<Void> {
        return requestAuthorization()
            .ensure({ $0 })
            .then(on: DispatchQueue.global(), { _ in
                self.notificationCenter.setNotificationCategories([self.makeCategory(for: .dailyDeal)])
            })
            .then({ _ in
                // must register on main thread
                UIApplication.shared.registerForRemoteNotifications()
            })
    }

    /// Unregister for all remote notifications received via Apple Push Notification service.
    func unregisterForRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    // MARK: - Helper Factory Methods

    private func makeCategory(for categoryID: NotificationCategoryIdentifier) -> UNNotificationCategory {
        let actions = makeActions(for: categoryID)
        return UNNotificationCategory(identifier: categoryID.rawValue,
                                      actions: actions,
                                      intentIdentifiers: categoryID.intentIdentifiers,
                                      options: categoryID.options)
    }

    private func makeActions(for categoryID: NotificationCategoryIdentifier) -> [UNNotificationAction] {
        let actions: [UNNotificationAction]
        switch categoryID {
        case .dailyDeal:
            let buyAction = UNNotificationAction(identifier: NotificationAction.buyAction.rawValue,
                                                 title: NotificationAction.buyAction.title,
                                                 options: NotificationAction.buyAction.options)
            let shareAction = UNNotificationAction(identifier: NotificationAction.shareAction.rawValue,
                                                   title: NotificationAction.shareAction.title,
                                                   options: NotificationAction.shareAction.options)
            actions = [buyAction, shareAction]
        }
        return actions
    }

}
