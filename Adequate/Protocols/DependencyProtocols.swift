//
//  DependencyProtocols.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

// MARK: - HasDependency Protocols

protocol HasImageService {
    var imageService: ImageServiceType { get }
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

// MARK: - Provider Protocols

protocol NotificationManagerProvider {
    func makeNotificationManager() -> NotificationManagerType
}
