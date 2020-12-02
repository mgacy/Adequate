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

// MARK: - UIUserInterfaceSizeClass + CustomStringConvertible
extension UIUserInterfaceSizeClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .compact: return "SizeClass.compact"
        case .regular: return "SizeClass.regular"
        case .unspecified: return "SizeClass.unspecified"
        @unknown default: return "SizeClass.unknown"
        }
    }
}

// MARK: - UIUserInterfaceLevel + CustomStringConvertible
extension UIUserInterfaceLevel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .base: return "InterfaceLevel.base"
        case .elevated: return "InterfaceLevel.elevated"
        case .unspecified: return "InterfaceLevel.unspecified"
        @unknown default: return "InterfaceLevel.unknown"
        }
    }
}

// MARK: - UIContentSizeCategory + CustomStringConvertible
extension UIContentSizeCategory: CustomStringConvertible {
    public var description: String {
        switch self {
        case .extraSmall: return "ContentSize.extraSmall"
        case .small: return "ContentSize.small"
        case .medium: return "ContentSize.medium"
        case .large: return "ContentSize.large"
        case .extraLarge: return "ContentSize.extraLarge"
        case .extraExtraLarge: return "ContentSize.extraExtraLarge"
        case .extraExtraExtraLarge: return "ContentSize.extraExtraExtraLarge"
        case .accessibilityMedium: return "ContentSize.accessibilityMedium"
        case .accessibilityLarge: return "ContentSize.accessibilityLarge"
        case .accessibilityExtraLarge: return "ContentSize.accessibilityExtraLarge"
        case .accessibilityExtraExtraLarge: return "ContentSize.accessibilityExtraExtraLarge"
        case .accessibilityExtraExtraExtraLarge: return "ContentSize.accessibilityExtraExtraExtraLarge"
        case .unspecified: return "ContentSize.unspecified"
        default: return "ContentSize.???: \(self)"
        //@unknown default: return "ContentSize.unknown"
        }
    }
}
