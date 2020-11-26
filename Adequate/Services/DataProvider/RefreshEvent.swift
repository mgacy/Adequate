//
//  RefreshEvent.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import enum UIKit.UIBackgroundFetchResult

enum RefreshEvent {
    /// Application did finish launching.
    case launch
    /// Application did finish launching from notification.
    case launchFromNotification(DealNotification)
    /// Application will enter foreground.
    case foreground
    // TODO: add case for coming back online?
    /// Application received foreground notification.
    case foregroundNotification

    /// Application received silent notification.
    case silentNotification((UIBackgroundFetchResult) -> Void)
    // TODO: implement
    //case silentNotification(notification: DealNotification, handler: (UIBackgroundFetchResult) -> Void)
    /// Manual refresh.
    case manual
}
