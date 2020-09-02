//
//  UserDefaultsManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/31/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

// MARK: - Keys
enum UserDefaultsKey: String {
    case hasShownOnboarding = "hasShownOnboarding"
    case showNotifications = "showNotifications"
    // AWS SNS
    case SNSEndpoint = "endpointArnForSNS"
    case SNSToken = "deviceTokenForSNS"
    case SNSSubscription = "subscriptionArnForSNS"
    // DataProvider
    case lastDealRequest = "lastDealRequest"
    case lastDealResponse = "lastDealResponse"
    //case lastDealCreatedAt = "lastDealCreatedAt"
}

// MARK: - Protocol
protocol UserDefaultsManagerType: AnyObject {
    var hasShownOnboarding: Bool { get set }
    var showNotifications: Bool { get set }
    // TODO: add `isMehVmp: Bool`
}

// MARK: - Implementation
final class UserDefaultsManager: UserDefaultsManagerType {
    let defaults: UserDefaults

    // MARK: - A

    var hasShownOnboarding: Bool {
        get {
            //return defaults.bool(forKey: UserDefaultsKey.hasShownOnboarding.rawValue)
            return bool(for: .hasShownOnboarding)
        }
        set {
            //defaults.set(newValue, forKey: UserDefaultsKey.hasShownOnboarding.rawValue)
            set(newValue, for: .hasShownOnboarding)
        }
    }

    var showNotifications: Bool {
        get {
            //return defaults.bool(forKey: UserDefaultsKey.showNotifications.rawValue)
            return bool(for: .showNotifications)
        }
        set {
            //defaults.set(newValue, forKey: UserDefaultsKey.showNotifications.rawValue)
            set(newValue, for: .showNotifications)
        }
    }

    // MARK: - B

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Read

    func bool(for key: UserDefaultsKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }

    // MARK: - Write

    func set(_ value: Bool, for key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

}
