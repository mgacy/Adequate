//
//  AppDependency.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import AWSAppSync
import AWSMobileClient

struct AppDependency: HasDataProvider, HasNotificationManager, HasThemeManager, HasUserDefaultsManager {
    let dataProvider: DataProviderType
    /// TODO: should we always carry this, or provide factory method so callers can create / destroy as needed?
    //func makeNotificationManager() -> NotificationManagerType {}
    let notificationManager: NotificationManagerType
    let themeManager: ThemeManagerType
    let userDefaultsManager: UserDefaultsManagerType

    init() {
        // Initialize client for auth
        AWSMobileClient.sharedInstance().initialize().catch { error in
            print("ERROR: \(error.localizedDescription)")
        }
        guard let appSyncClient = AppDependency.makeAppSyncClient(cacheKey: "id") else {
            fatalError("Unable to initialize AppSyncClient")
        }
        let networkClient = AppDependency.makeNetworkClient()
        let mehService = MehService(client: networkClient)
        self.dataProvider = DataProvider(appSync: appSyncClient, mehService: mehService)

        self.userDefaultsManager = UserDefaultsManager(defaults: .standard)

        // Notifications
        self.notificationManager = NotificationManager()
        if userDefaultsManager.showNotifications {
            notificationManager.registerForPushNotifications().catch({ error in
                print("ERROR: \(error)")
            })
        }

        // Accent color from HIG:
        // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color/
        let defaultTheme = Theme(accentColor: "#007AFF", backgroundColor: "#ffffff", foreground: .dark)
        self.themeManager = ThemeManager(theme: defaultTheme)
    }

    // MARK: - Factory Functions

    static private func makeNetworkClient() -> NetworkClientType {
        // Configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8  // seconds
        configuration.timeoutIntervalForResource = 8 // seconds
        //configuration.waitsForConnectivity = true    // reachability

        // JSON Decoding
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

        return NetworkClient(configuration: configuration, decoder: decoder)
    }

    private static func makeAppSyncClient(cacheKey: String) -> AWSAppSyncClient? {
        do {
            // Initialize the AWS AppSync configuration
            // https://aws-amplify.github.io/docs/ios/api#iam
            let appSyncConfig = try AWSAppSyncClientConfiguration(appSyncServiceConfig: AWSAppSyncServiceConfig(),
                                                                  credentialsProvider: AWSMobileClient.sharedInstance(),
                                                                  cacheConfiguration: AWSAppSyncCacheConfiguration())

            let client = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            client.apolloClient?.cacheKeyForObject = { $0[cacheKey] }
            return client
        } catch {
            print("Error initializing appsync client. \(error)")
        }
        return nil
    }

}