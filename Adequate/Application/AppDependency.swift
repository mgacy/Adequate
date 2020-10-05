//
//  AppDependency.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import AWSMobileClient

class AppDependency: HasDataProvider, HasImageService, HasNotificationManager, HasThemeManager, HasUserDefaultsManager {
    let dataProvider: DataProviderType
    let imageService: ImageServiceType
    // TODO: should we always carry this, or provide factory method so callers can create / destroy as needed?
    //func makeNotificationManager() -> NotificationManagerType {}
    let notificationManager: NotificationManagerType
    let themeManager: ThemeManagerType
    let userDefaultsManager: UserDefaultsManagerType

    init() {
        // https://aws-amplify.github.io/docs/ios/authentication
        let credentialsProvider = AWSMobileClient.default()

        // Initialize dataProvider
        self.dataProvider = DataProvider(credentialsProvider: credentialsProvider)

        let networkClient = AppDependency.makeNetworkClient()
        self.imageService = ImageService(client: networkClient)

        let userDefaultsManager = UserDefaultsManager(defaults: .standard)
        self.userDefaultsManager = userDefaultsManager

        // Notifications
        self.notificationManager = NotificationManager()
        if userDefaultsManager.showNotifications {
            notificationManager.registerForPushNotifications().catch({ error in
                log.error("Unable to register for push notifications: \(error)")
            })
        }

        let theme = AppTheme(interfaceStyle: userDefaultsManager.interfaceStyle)
        self.themeManager = ThemeManager(dataProvider: dataProvider, theme: theme)
    }

    // MARK: - Factory Functions

    static private func makeNetworkClient() -> NetworkClientType {
        // Configuration
        let configuration = URLSessionConfiguration.default
        //configuration.timeoutIntervalForRequest = 8  // seconds
        //configuration.timeoutIntervalForResource = 8 // seconds
        //configuration.waitsForConnectivity = true    // reachability

        // Disable caching since we are going to use our own caches.
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil

        // JSON Decoding
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

        return NetworkClient(configuration: configuration, decoder: decoder)
    }
}
