//
//  NotificationManagerType.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/5/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Promise

protocol NotificationManagerType {

    /// Returns the notification authorization status for this app.
    func isAuthorized() -> Promise<Bool>

    /// Request authorization to interact with the user when local and remote notifications are delivered to their
    /// device.
    func requestAuthorization() -> Promise<Bool>

    /// Register to receive remote notifications via Apple Push Notification service.
    func registerForPushNotifications() -> Promise<Void>

    /// Unregister for all remote notifications received via Apple Push Notification service.
    func unregisterForRemoteNotifications()
}
