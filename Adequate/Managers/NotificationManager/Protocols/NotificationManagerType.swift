//
//  NotificationManagerType.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/5/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Promise

protocol NotificationManagerType {
    func isAuthorized() -> Promise<Bool>
    func requestAuthorization() -> Promise<Bool>
    func registerForPushNotifications() -> Promise<Void>
    func unregisterForRemoteNotifications()
}
