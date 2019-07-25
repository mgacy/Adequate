//
//  HasProtocols.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

protocol HasImageService {
    var imageService: ImageServiceType { get }
}

protocol HasNotificationManager {
    var notificationManager: NotificationManagerType { get }
}

protocol HasUserDefaultsManager {
    var userDefaultsManager: UserDefaultsManagerType { get }
}

protocol HasThemeManager {
    var themeManager: ThemeManagerType { get }
}

protocol HasDataProvider {
    var dataProvider: DataProviderType { get }
}
