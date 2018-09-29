//
//  AppDependency.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct AppDependency: HasClient, HasMehService, HasNotificationManager {
    let client: NetworkClientType
    let mehService: MehServiceType
    /// TODO: should we always carry this, or provide factory method so callers can create / destroy as needed?
    //func makeNotificationManager() -> NotificationManagerType {}
    let notificationManager: NotificationManagerType

    init() {
        self.client = NetworkClient()

        // Configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8  // seconds
        configuration.timeoutIntervalForResource = 8 // seconds
        //configuration.waitsForConnectivity = true    // reachability

        // JSON Decoding
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

        let mehClient = NetworkClient(configuration: configuration, decoder: decoder)
        self.mehService = MehService(client: mehClient)

        self.notificationManager = NotificationManager()

        // Notifications
        if UserDefaults.standard.bool(forKey: "showNotifications") {
            notificationManager.registerForPushNotifications().catch({ error in
                print("ERROR: \(error)")
            })
        }

    }

}
