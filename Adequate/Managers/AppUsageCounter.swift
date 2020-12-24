//
//  AppUsageCounter.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/10/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

// MARK: - Protocol
protocol AppUsageCounting {

    /// Returns the number of times the user has performed the app action.
    /// - Parameter action: An application action.
    func countFor(_ action: AppAction) -> Int

    /// Increment the count for an app action.
    /// - Parameter action: The action the user performed.
    /// - Returns: The updated count for `action`.
    @discardableResult
    func userDid(perform action: AppAction) -> Int
}

// MARK: - Type
enum AppAction {
    case launchApp
    case pressBuy
    case shareDeal
    //case actionFromNotification(NotificationAction)
    //case launchFromNotification
    //case launchFromWidget
}

// MARK: - Implementation
class AppUsageCounter: AppUsageCounting {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Returns the number of times the user has performed the app action.
    /// - Parameter action: An application action.
    func countFor(_ action: AppAction) -> Int {
        return defaults.integer(for: action.defaultsKey)
    }

    /// Increment the count for an app action.
    /// - Parameter action: The action the user performed.
    /// - Returns: The updated count for `action`.
    @discardableResult
    func userDid(perform action: AppAction) -> Int {
        var count = defaults.integer(for: action.defaultsKey)
        count += 1
        defaults.set(count, for: action.defaultsKey)
        return count
    }
}

// MARK: - AppAction+UserDefaultsKey
extension AppAction {

    var defaultsKey: UserDefaultsKey {
        switch self {
        case .launchApp: return .appLaunchCount
        case .pressBuy: return .pressedBuyCount
        case .shareDeal: return .sharedDealCount
        //case .actionFromNotification: return .
        //case .launchFromNotification: return .
        //case .launchFromWidget: return .
        }
    }
}
