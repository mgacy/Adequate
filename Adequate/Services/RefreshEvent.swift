//
//  RefreshEvent.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

enum RefreshEvent {
    /// Application did finish launching.
    case launch
    /// Application did finish launching from notification.
    case launchFromNotification([String: AnyObject])
    /// Application will enter foreground.
    case foreground

    /// Application received foreground notification.
    case foregroundNotification

    /// Application received silent notification.
    case silentNotification((UIBackgroundFetchResult) -> Void)
    /// Manual refresh.
    case manual
}
