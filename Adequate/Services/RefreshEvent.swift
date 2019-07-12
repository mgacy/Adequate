//
//  RefreshEvent.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

enum RefreshEvent {

    /// Manual refresh
    case manual

    // MARK: App State

    /// Application did finish launching
    case launch

    /// Application will enter foreground
    case foreground

    // MARK: Notification

    /// Application received foreground notification
    case foregroundNotification

    /// Application received silent notification
    case silentNotification((UIBackgroundFetchResult) -> Void)
}
