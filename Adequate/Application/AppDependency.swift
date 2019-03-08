//
//  AppDependency.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct AppDependency: HasDataProvider, HasMehService, HasNotificationManager, HasThemeManager, HasUserDefaultsManager {
    let mehService: MehServiceType
    /// TODO: should we always carry this, or provide factory method so callers can create / destroy as needed?
    //func makeNotificationManager() -> NotificationManagerType {}
    let notificationManager: NotificationManagerType
    let themeManager: ThemeManagerType
    let userDefaultsManager: UserDefaultsManagerType
    let dataProvider: DataProviderType

    init() {
        let networkClient = AppDependency.makeNetworkClient()
        self.mehService = MehService(client: networkClient)

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
        self.dataProvider = DataProvider(mehService: self.mehService)
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

}
