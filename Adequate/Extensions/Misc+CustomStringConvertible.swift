//
//  CustomStringConvertible.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/30/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - UIApplication.State
extension UIApplication.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .background:
            return "background"
        @unknown default:
            return "Unknown UIApplication.State"
        }
    }
}

// MARK: - UIBackgroundFetchResult
extension UIBackgroundFetchResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failed:
            return "failed"
        case .newData:
            return "newData"
        case .noData:
            return "noData"
        @unknown default:
            return "Unknown UIBackgroundFetchResult"
        }
    }
}
