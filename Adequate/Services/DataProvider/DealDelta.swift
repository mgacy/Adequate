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

    enum NotificationUpdateType: String {
        //case newDeal
        case commentCount
        case launchStatus
        // TODO: use indirect enum with case multiple([UpdateType])?
        //case multiple
    }

    init?(userInfo: [AnyHashable : Any]) {
        if
            let updateTypeString = userInfo[NotificationPayloadKey.deltaType] as? String,
            let updateType = NotificationPayloadKey.DeltaType(rawValue: updateTypeString) {

            switch updateType {
            //case .newDeal:
            //    log.debug("NEW DEAL")
            //    self = .newDeal
            case .commentCount:
                guard let count = userInfo[NotificationPayloadKey.deltaValue] as? Int else {
                    log.error("Incorrect notification: \(userInfo)")
                    return nil
                }
                //log.debug("COMMENT COUNT: \(count)")
                self = .commentCount(count)
            case .launchStatus:
                guard
                    let status = userInfo[NotificationPayloadKey.deltaValue] as? String,
                    let launchStatus = LaunchStatus(rawValue: status) else {
                        log.error("Incorrect notification: \(userInfo)")
                        return nil
                }
                //log.debug("LAUNCH STATUS: \(launchStatus)")
                self = .launchStatus(launchStatus)
            //case .multiple:
            //    log.debug("MULTIPLE UPDATES")
            //    return nil
            }
        } else {
            self = .newDeal
        }
    }
}
