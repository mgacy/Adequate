//
//  NotificationServiceManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/5/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Promise

/// Register device with push notification provider server.
protocol NotificationServiceManager {

    /// Register device with push notification service provider.
    /// - Parameter token: Unique token identifying this device with Apple Push Notification service.
    /// - Returns: Identifier from push notification service provider.
    func registerDevice(with token: String) -> Promise<String>
}
