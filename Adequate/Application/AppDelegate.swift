//
//  AppDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import AWSSNS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Initialize the Amazon Cognito credentials provider
        configurePushService(region: .USWest2)

        /// TODO: create NotificationManager here and inject into AppCoordinator / create delegate protocol?
        self.appCoordinator = AppCoordinator(window: self.window!)
        /// TODO: check if app launched from notification
        self.appCoordinator.start()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Notifications

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        createPlatformEndpoint(with: token)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }

}

// MARK: - AWS Integration
/// TODO: put in separate object
extension AppDelegate {

    func configurePushService(region: AWSRegionType) {
        // Initialize the Amazon Cognito credentials provider
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region,
                                                                identityPoolId: AppSecrets.identityPoolId)
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    /// TODO: should this return a promise?
    /// TODO: should UserDefaults be handled elsewhere?
    func createPlatformEndpoint(with token: String) {
        UserDefaults.standard.set(token, forKey: "deviceTokenForSNS")

        guard let request = AWSSNSCreatePlatformEndpointInput() else {
            print("ERROR: unable to create AWSSNSCreatePlatformEndpointInput"); return
        }
        request.token = token
        request.platformApplicationArn = AppSecrets.platformApplicationArn

        let sns = AWSSNS.default()
        /// TODO: perform on background thread?
        sns.createPlatformEndpoint(request: request).then({ response in
            guard let endpointArnForSNS = response.endpointArn else {
                /// TODO: improve error handling
                fatalError("Missing Platform Endpoint ARN")
            }
            print("endpointArn: \(endpointArnForSNS)")
            UserDefaults.standard.set(endpointArnForSNS, forKey: "endpointArnForSNS")
        }).catch({ error in
            /// TODO: improve error handling
            print("ERROR: unable to create AWS SNS platform endpoint")
        })
    }

}
