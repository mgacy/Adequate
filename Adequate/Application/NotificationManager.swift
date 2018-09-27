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

class NotificationManager: NotificationManagerType {

    let notificationCenter: UNUserNotificationCenter

    init() {
        notificationCenter = .current()
    }

}
