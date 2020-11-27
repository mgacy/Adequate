//
//  RefreshEvent.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import enum UIKit.UIBackgroundFetchResult
import struct UIKit.UNNotificationPresentationOptions

enum RefreshEvent {
    /// Application did finish launching.
    case launch
    /// Application did finish launching from notification.
    case launchFromNotification(DealNotification)
    /// Application will enter foreground.
    case foreground
    // TODO: add case for coming back online?
    /// Application received foreground notification.
    case foregroundNotification(notification: DealNotification, handler: (UNNotificationPresentationOptions) -> Void)

    /// Application received silent notification.
    case silentNotification(notification: DealNotification, handler: (UIBackgroundFetchResult) -> Void)
    /// Manual refresh.
    case manual
}
