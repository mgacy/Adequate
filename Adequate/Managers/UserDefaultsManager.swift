//
//  UserDefaultsManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/31/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation
import enum UIKit.UIUserInterfaceStyle

// MARK: - Keys
enum UserDefaultsKey: String {
    case hasShownOnboarding
    // App Usage
    case appLaunchCount
    case pressedBuyCount
    case sharedDealCount
    // App Store Reviews
    case firstAppLaunch
    case lastVersionPromptedForReview
    // Settings
    case showNotifications
    case interfaceStyle
    //case openLinksInSafari
    // AWS SNS
    case SNSEndpoint = "endpointArnForSNS"
    case SNSToken = "deviceTokenForSNS"
    case SNSSubscription = "subscriptionArnForSNS"
    // DataProvider
    case lastDealRequest
    case lastDealResponse
    case lastDealCreatedAt
}

// MARK: - Protocol
protocol UserDefaultsManagerType: AnyObject {
    var hasShownOnboarding: Bool { get set }
    // Settings
    var showNotifications: Bool { get set }
    var interfaceStyle: UIUserInterfaceStyle { get set }
    //var isMehVmp: Bool
}

// MARK: - Implementation
final class UserDefaultsManager: UserDefaultsManagerType {
    let defaults: UserDefaults

    // MARK: - A

    var hasShownOnboarding: Bool {
        get {
            return defaults.bool(for: .hasShownOnboarding)
        }
        set {
            defaults.set(newValue, for: .hasShownOnboarding)
        }
    }

    var interfaceStyle: UIUserInterfaceStyle {
        get {
            let rawValue = defaults.integer(for: .interfaceStyle)
            return UIUserInterfaceStyle(rawValue: rawValue) ?? .unspecified
        }
        set {
            defaults.set(newValue.rawValue, for: .interfaceStyle)
        }
    }

    var showNotifications: Bool {
        get {
            return defaults.bool(for: .showNotifications)
        }
        set {
            defaults.set(newValue, for: .showNotifications)
        }
    }

    // MARK: - B

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}

// MARK: - UserDefaults+UserDefaultsKey
extension UserDefaults {

    // MARK: - Read

    func bool(for key: UserDefaultsKey) -> Bool {
        return bool(forKey: key.rawValue)
    }

    func codable<T: Codable>(for key: UserDefaultsKey) throws -> T? {
        guard let data = object(forKey: key.rawValue) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    func integer(for key: UserDefaultsKey) -> Int {
        return integer(forKey: key.rawValue)
    }

    func string(for key: UserDefaultsKey) -> String? {
        return string(forKey: key.rawValue)
    }

    // MARK: - Write

    func set(_ value: Bool, for key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }

    func set<T: Codable>(_ value: T, for key: UserDefaultsKey) throws {
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(value)
        set(encoded, forKey: key.rawValue)
    }

    func set(_ value: Int, for key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }

    func set(_ value: String, for key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }

    func set(_ value: String?, for key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }
}
