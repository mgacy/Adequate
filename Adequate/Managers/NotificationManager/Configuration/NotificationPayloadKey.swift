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

    /// Key for the id of the `Deal` to which the notification applies.
    static let dealID = "deal-id"

    // MARK: - New Deal

    /// Key for the URL of the `Deal` on meh.com.
    static let dealURL = "deal-url"

    /// Key for the URL of the first image for the `Deal`.
    static let imageURL = "image-url"

    // MARK: - Deal Delta

    /// Key for the `DeltaType` carried by the notification.
    static let deltaType = "delta-type"

    /// Key for the associated value of the `DeltaType` carried by the notification.
    static let deltaValue = "delta-value"

    // TODO: embed `DeltaTypeValue` and any future types of similar purpose in `NotificationPayloadValue` enum?

    /// Values allowed for `deltaType`. Corresponds to `DeltaType`.
    enum DeltaTypeValue: String {
        case newDeal
        case commentCount
        case launchStatus
        // TODO: use indirect enum with case multiple([UpdateType])?
        //case multiple
    }
}
