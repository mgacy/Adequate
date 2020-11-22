//
//  DealDelta.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

/// Representation of notification content.
struct DealDelta {
    let dealID: String
    let deltaType: DeltaType

    init?(userInfo: [AnyHashable : Any]) {
        guard
            let dealID = userInfo[NotificationPayloadKey.dealID] as? String,
            let deltaType = DeltaType(userInfo: userInfo) else {
                return nil
        }
        self.dealID = dealID
        self.deltaType = deltaType
    }
}

enum DeltaType {
    case newDeal//(dealURL: URL, imageURL: URL)
    case commentCount(Int)
    case launchStatus(LaunchStatus)

    init?(userInfo: [AnyHashable : Any]) {
        if
            let updateTypeString = userInfo[NotificationPayloadKey.deltaType] as? String,
            let updateType = ValueType(rawValue: updateTypeString) {

            switch updateType {
            //case .newDeal:
            //    self = .newDeal
            case .commentCount:
                guard let count = userInfo[NotificationPayloadKey.deltaValue] as? Int else {
                    return nil
                }
                self = .commentCount(count)
            case .launchStatus:
                guard
                    let status = userInfo[NotificationPayloadKey.deltaValue] as? String,
                    let launchStatus = LaunchStatus(rawValue: status) else {
                        return nil
                }
                self = .launchStatus(launchStatus)
            }
        } else {
            self = .newDeal
            // TODO: have separate initializers for alert and silent notification?
            //guard
            //    let dealURLString = userInfo[NotificationPayloadKey.dealURL] as? String,
            //    let dealURL = URL(string: dealURLString),
            //    let imageURLString = userInfo[NotificationKey.imageURL] as? String,
            //    let imageURL = URL(string: imageURLString) else {
            //        return nil
            //}
            //self = .newDeal(dealURL: dealURL, imageURL: imageURL)
        }
    }

    /// Values for `NotificationPayloadKey.deltaType`
    enum ValueType: String {
        case commentCount
        case launchStatus
    }
}
