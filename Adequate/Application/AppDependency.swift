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
        let credentialsProvider = AWSMobileClient.sharedInstance()

        // Initialize dataProvider
        let dataProvider: DataProviderType
        do {
            dataProvider = try DataProvider(credentialsProvider: credentialsProvider)
        } catch {
            log.error("Unable to initialize AWSAppSyncClient: \(error)")
            dataProvider = MockDataProvider(error: error)
        }
        self.dataProvider = dataProvider

        let networkClient = AppDependency.makeNetworkClient()
        self.imageService = ImageService(client: networkClient)

        self.userDefaultsManager = UserDefaultsManager(defaults: .standard)

        // Notifications
        self.notificationManager = NotificationManager()
        if userDefaultsManager.showNotifications {
            notificationManager.registerForPushNotifications().catch({ error in
                log.error("Unable to register for push notifications: \(error)")
            })
        }

        self.themeManager = ThemeManager(dataProvider: dataProvider, theme: AppTheme.system)
    }

    // MARK: - Factory Functions

    static private func makeNetworkClient() -> NetworkClientType {
        // Configuration
        let configuration = URLSessionConfiguration.default
        //configuration.timeoutIntervalForRequest = 8  // seconds
        //configuration.timeoutIntervalForResource = 8 // seconds
        //configuration.waitsForConnectivity = true    // reachability

        // JSON Decoding
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

        return NetworkClient(configuration: configuration, decoder: decoder)
    }
}
