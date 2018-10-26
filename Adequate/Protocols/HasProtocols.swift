//
//  HasProtocols.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

protocol HasClient {
    var client: NetworkClientType { get }
}

protocol HasMehService {
    var mehService: MehServiceType { get }
}

protocol HasNotificationManager {
    var notificationManager: NotificationManagerType { get }
}

protocol HasThemeManager {
    var themeManager: ThemeManagerType { get }
}
