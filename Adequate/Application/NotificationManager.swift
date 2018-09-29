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
    func registerForPushNotifications() -> Promise<Void>
}

// MARK: - Errors

enum NotificationManagerError: Error {
    case unauthorized
    case general(message: String)
}

// MARK: - Configuration

//struct NotificationConfig {}

// MARK: - Implementation

class NotificationManager: NSObject, NotificationManagerType {

    let notificationCenter: UNUserNotificationCenter

    override init() {
        notificationCenter = .current()
        super.init()
        notificationCenter.delegate = self
    }

    // MARK: - NotificationManagerType

    @discardableResult
    func registerForPushNotifications() -> Promise<Void> {
        let options: UNAuthorizationOptions = [.alert, .sound]
        return notificationCenter.requestAuthorization(options: options)
            .ensure({ $0 })
            .then({ _ -> Promise<UNNotificationSettings> in
                return self.notificationCenter.getNotificationSettings()
            })
            .ensure({ $0.authorizationStatus == .authorized })
            .then({ settings in
                //print("Notification settings: \(settings)")
                // .setNotificationCategories([])
                UIApplication.shared.registerForRemoteNotifications()
            })
    }

}

extension NotificationManager: UNUserNotificationCenterDelegate {

    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // ...
        completionHandler([.alert, .sound])
    }

    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        //let userInfo = response.notification.request.content.userInfo
        //let aps = userInfo["aps"] as! [String: AnyObject]
        // ...
        completionHandler()
    }

}
