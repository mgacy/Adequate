//
//  UNUserNotificationCenter+Promise.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UserNotifications
import Promise

extension UNUserNotificationCenter {

    func add(_ request: UNNotificationRequest) -> Promise<Void> {
        return Promise<Void>(work: { [weak self] fulfill, reject in
            self?.add(request) { error in
                guard error == nil else {
                    return reject(error!)
                }
                fulfill(())
            }
        })
    }

    func getNotificationSettings() -> Promise<UNNotificationSettings> {
        return Promise<UNNotificationSettings>(work: { [weak self] fulfill, reject in
            self?.getNotificationSettings { settings in
                fulfill(settings)
            }
        })
    }

    func requestAuthorization(options: UNAuthorizationOptions = []) -> Promise<Bool> {
        return Promise<Bool>(work: { [weak self] fulfill, reject in
            self?.requestAuthorization(options: options) { (granted, maybeError) in
                if let error = maybeError {
                    reject(error)
                } else {
                    fulfill(granted)
                }
            }
        })
    }

}
