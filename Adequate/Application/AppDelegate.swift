//
//  AppDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private var notificationServiceManager: NotificationServiceManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        UNUserNotificationCenter.current().delegate = self

        // Check if launched from notification
        let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
        let deepLink = DeepLink.build(with: notification)

        /// TODO: create NotificationManager here and inject into AppCoordinator / create delegate protocol?
        self.appCoordinator = AppCoordinator(window: self.window!)
        self.appCoordinator.start(with: deepLink)
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

    // MARK: - URL-Specified Resources

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let deepLink = DeepLink.build(with: url)
        appCoordinator.start(with: deepLink)
        return true
    }

    // MARK: - Notifications

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")

        notificationServiceManager = AWSManager(region: .USWest2)
        notificationServiceManager?.registerDevice(with: token)
            .then({ [weak self] subscriptionArn in
                print("subscriptionArn: \(subscriptionArn)")
                self?.notificationServiceManager = nil
            })
            .catch({error in
                print("ERROR: \(error)")
            })
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }

}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // TODO: refresh DealViewController
        completionHandler([.alert, .sound])
    }

    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo

        switch response.actionIdentifier {
        case NotificationAction.buyAction.rawValue:
            if let urlString = userInfo[NotificationConstants.dealKey] as? String, let buyURL = URL(string: urlString) {
                appCoordinator.start(with: .buy(buyURL))
            } else {
                print("ERROR: unable to parse \(NotificationConstants.dealKey) from Notification")
            }
        case NotificationAction.mehAction.rawValue:
            appCoordinator.start(with: .meh)
        default:
            print("Unknown Action")
        }
        completionHandler()
    }

}
