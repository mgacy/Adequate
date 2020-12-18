//
//  AppDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import UserNotifications

let log = Logger.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appDependency: AppDependency!
    private var appCoordinator: AppCoordinator!
    private var notificationServiceManager: NotificationServiceManager?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        log.debug("\(#function) - \(String(describing: launchOptions))")
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // TODO: should we just make `AppCoordinator` the delegate since we currently handle by passing off to it anyway?
        // Or should we make a separate `AppController` and maintain single role of `AppCoordinator`?
        UNUserNotificationCenter.current().delegate = self

        let deepLink = DeepLink.build(with: launchOptions)

        self.appDependency = AppDependency()
        self.appCoordinator = AppCoordinator(window: self.window!, dependencies: self.appDependency)
        self.appCoordinator.start(with: deepLink)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of
        // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the
        // application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        log.verbose("WILL_RESIGN_ACTIVE")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application
        // state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate:
        // when the user quits.
        log.verbose("DID_ENTER_BACKGROUND")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the
        // changes made on entering the background.
        log.verbose("WILL_ENTER_FOREGROUND")
        appCoordinator.refreshDeal(for: .foreground)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the
        // application was previously in the background, optionally refresh the user interface.
        log.verbose("DID_BECOME_ACTIVE")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        log.debug("WILL_TERMINATE")
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        log.warning("Memory Warning")
        // TODO: clear cache on ImageService
    }

    // MARK: - URL-Specified Resources

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        let deepLink = DeepLink.build(with: url)
        log.verbose("\(#function) - url: \(url) - options: \(options) - deepLink: \(String(describing: deepLink))")
        appCoordinator.start(with: deepLink)
        return true
    }

    // MARK: - Notifications

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        notificationServiceManager = appDependency.makeNotificationServiceManager()
        notificationServiceManager?.registerDevice(with: token)
            .then({ [weak self] subscriptionArn in
                self?.notificationServiceManager = nil
            })
            .catch({ [weak self] error in
                log.error("ERROR: \(error)")
                // TODO: improve error handling
                self?.notificationServiceManager = nil
            })
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        log.error("Failed to register for remote notifications with error: \(error)")
        // TODO: disable notification-related functions
    }

    // MARK: - Background App Refresh

    // FIXME: remove
    // see https://developer.apple.com/forums/thread/130138 about this method being called if `content-availble: 1`
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        log.error("****\(#function) was called for some reason")
        completionHandler(.newData)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Called for silent notifications.
        // FIXME: this can be called a second time when user presses notification
        // TODO: see: https://stackoverflow.com/a/33778990/4472195, https://stackoverflow.com/q/16393673
        log.debug("\(#function) - \(userInfo) - \(application.applicationState.rawValue)")
        guard let notification = DealNotification(userInfo: userInfo) else {
            log.error("Unable to parse DealNotification from notification: \(userInfo)")
            completionHandler(.failed)
            return
        }
        appCoordinator.refreshDeal(for: .silentNotification(notification: notification, handler: completionHandler))
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        log.debug("\(#function) - \(notification)")
        guard let notification = DealNotification(userInfo: notification.request.content.userInfo) else {
            // TODO: how best to handle? Call with `[]`?
            completionHandler(UNNotificationPresentationOptions(rawValue: 0))  // skip notification
            return
        }
        appCoordinator.refreshDeal(for: .foregroundNotification(notification: notification, handler: completionHandler))
    }

    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        log.debug("\(#function) - \(response)")

        let deepLink = DeepLink.build(with: response)
        appCoordinator.start(with: deepLink)
        completionHandler()
    }

}
