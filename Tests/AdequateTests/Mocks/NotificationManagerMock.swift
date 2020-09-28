//
//  NotificationManagerMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Promise
@testable import Adequate

class NotificationManagerMock: NotificationManagerType {

    var authorized: Bool = true

    // MARK: - NotificationManagerType

    func isAuthorized() -> Promise<Bool> {
        return Promise(value: authorized)
    }

    func requestAuthorization() -> Promise<Bool> {
        return Promise(value: authorized)
    }

    func registerForPushNotifications() -> Promise<Void> {
        return Promise(value: ())
    }

    func unregisterForRemoteNotifications() {
        authorized = false
    }
}
