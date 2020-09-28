//
//  UserDefaultsManagerMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

@testable import Adequate

class UserDefaultsManagerMock: UserDefaultsManagerType {

    var _hasShownOnboarding: Bool = true
    var _showNotifications: Bool = true

    // MARK: - UserDefaultsManagerType

    var hasShownOnboarding: Bool {
        get {
            return _hasShownOnboarding
        }
        set {
            _hasShownOnboarding = newValue
        }
    }

    var showNotifications: Bool {
        get {
            return _showNotifications
        }
        set {
            _showNotifications = newValue
        }
    }
}
