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
    func registerDevice(with token: String) -> Promise<String>
}
