//
//  DealDelta.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

// TODO: make a struct with a `dealID` and `updateType` property?
enum DealDelta {
    case newDeal
    case commentCount(Int)
    case launchStatus(LaunchStatus)

    init?(userInfo: [AnyHashable : Any]) {
        if
            let updateTypeString = userInfo[NotificationPayloadKey.deltaType] as? String,
            let updateType = NotificationPayloadKey.DeltaType(rawValue: updateTypeString) {

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
            //case .multiple:
            //    return nil
            }
        } else {
            self = .newDeal
        }
    }
}
