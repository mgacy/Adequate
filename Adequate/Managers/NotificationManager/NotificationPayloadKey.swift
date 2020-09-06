//
//  NotificationPayloadKey.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/5/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

/// Keys used in notification payload
enum NotificationPayloadKey {
    static let dealID = "deal-id"

    // New Deal
    static let dealURL = "deal-url"
    static let imageURL = "image-url"

    // Deal Delta
    static let deltaType = "delta-type"
    static let deltaValue = "delta-value"

    /// Values allowed for `deltaType`
    enum DeltaType: String {
        case newDeal
        case commentCount
        case launchStatus
        // TODO: use indirect enum with case multiple([UpdateType])?
        //case multiple
    }
}
