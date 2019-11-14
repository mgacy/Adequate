//
//  DealDelta.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

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
            let updateTypeString = userInfo[NotificationConstants.deltaTypeKey] as? String,
            let updateType = NotificationUpdateType(rawValue: updateTypeString) {

            switch updateType {
            //case .newDeal:
            //    log.debug("NEW DEAL")
            //    self = .newDeal
            case .commentCount:
                guard let count = userInfo[NotificationConstants.deltaValueKey] as? Int else {
                    log.error("Incorrect notification: \(userInfo)")
                    return nil
                }
                //log.debug("COMMENT COUNT: \(count)")
                self = .commentCount(count)
            case .launchStatus:
                guard
                    let status = userInfo[NotificationConstants.deltaValueKey] as? String,
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
