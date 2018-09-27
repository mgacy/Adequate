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

protocol NotificationManagerType {}

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

}

extension NotificationManager: UNUserNotificationCenterDelegate {

    // Handle notifications when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // ...
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        //let userInfo = response.notification.request.content.userInfo
        //let aps = userInfo["aps"] as! [String: AnyObject]
        // ...
        completionHandler()
    }

}
