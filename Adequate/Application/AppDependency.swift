//
//  AppDependency.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import AWSMobileClient
import class MGNetworking.NetworkClient

class AppDependency: HasDataProvider, HasImageService, HasThemeManager, HasUserDefaultsManager {
    let credentialsProvider: AWSCredentialsProvider
    let dataProvider: DataProviderType
    let imageService: ImageServiceType
    let themeManager: ThemeManagerType
    let userDefaultsManager: UserDefaultsManagerType

    init() {
        let credentialsProvider = AWSMobileClient.default()
        self.credentialsProvider = credentialsProvider

        // TODO: go ahead and configure AWSServiceManager.default().defaultServiceConfiguration here?

        // Initialize dataProvider
        self.dataProvider = DataProvider(credentialsProvider: credentialsProvider)

        self.imageService = Self.makeImageService()

        let userDefaultsManager = UserDefaultsManager(defaults: .standard)
        self.userDefaultsManager = userDefaultsManager

        let theme = AppTheme(interfaceStyle: userDefaultsManager.interfaceStyle)
        self.themeManager = ThemeManager(dataProvider: dataProvider, theme: theme)
    }

    // MARK: - Factory Functions

    static private func makeImageService() -> ImageServiceType {
        // Configuration
        let configuration = URLSessionConfiguration.default
        //configuration.timeoutIntervalForRequest = 8  // seconds
        //configuration.timeoutIntervalForResource = 8 // seconds
        //configuration.waitsForConnectivity = true    // reachability

        // Disable caching since we are going to use our own caches.
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil

        let networkClient = MGNetworking.NetworkClient(configuration: configuration)
        return NewImageService(client: networkClient)
    }
}

// MARK: - AppUsageCounterProvider
extension AppDependency: AppUsageCounterProvider {
    func makeAppUsageCounter() -> AppUsageCounting {
        return AppUsageCounter(defaults: .standard)
    }
}

// MARK: - NotificationManagerProvider
extension AppDependency: NotificationManagerProvider {

    func makeNotificationManager() -> NotificationManagerType {
        return NotificationManager()
    }
}

// MARK: - NotificationServiceManagerProvider
extension AppDependency: NotificationServiceManagerProvider {

    func makeNotificationServiceManager() -> NotificationServiceManager {
        return SNSManager(configuration: AppSecrets.self, credentialsProvider: credentialsProvider)
    }
}
