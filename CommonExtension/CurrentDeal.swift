//
//  CurrentDeal.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

public struct CurrentDeal: Codable {
    public let id: String
    public let title: String
    public let imageURL: URL
    public let minPrice: Double
    public let maxPrice: Double?
    //public let priceComparison: String?
    //public let createdAt: Date
    //public let updatedAt: Date
    //public let endDate: Date?
    public let launchStatus: LaunchStatus?
}

// MARK: - Equatable
extension CurrentDeal: Equatable {}

// MARK: - Types
extension CurrentDeal {

    // Duplicate so we don't need to include entirety of `API.swift`
    public enum LaunchStatus: RawRepresentable, Equatable, Codable {
        // swiftlint:disable:next nesting
        public typealias RawValue = String
        case launch
        case launchSoldOut
        case relaunch
        case relaunchSoldOut
        case reserve
        case soldOut
        case expired
        /// Auto generated constant for unknown enum values
        case unknown(RawValue)

        public init?(rawValue: RawValue) {
            switch rawValue {
            case "launch": self = .launch
            case "launchSoldOut": self = .launchSoldOut
            case "relaunch": self = .relaunch
            case "relaunchSoldOut": self = .relaunchSoldOut
            case "reserve": self = .reserve
            case "soldOut": self = .soldOut
            case "expired": self = .expired
            default: self = .unknown(rawValue)
            }
        }

        public var rawValue: RawValue {
            switch self {
            case .launch: return "launch"
            case .launchSoldOut: return "launchSoldOut"
            case .relaunch: return "relaunch"
            case .relaunchSoldOut: return "relaunchSoldOut"
            case .reserve: return "reserve"
            case .soldOut: return "soldOut"
            case .expired: return "expired"
            case .unknown(let value): return value
            }
        }

        public static func == (lhs: LaunchStatus, rhs: LaunchStatus) -> Bool {
            switch (lhs, rhs) {
            case (.launch, .launch): return true
            case (.launchSoldOut, .launchSoldOut): return true
            case (.relaunch, .relaunch): return true
            case (.relaunchSoldOut, .relaunchSoldOut): return true
            case (.reserve, .reserve): return true
            case (.soldOut, .soldOut): return true
            case (.expired, .expired): return true
            case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
            default: return false
            }
        }
    }
}
