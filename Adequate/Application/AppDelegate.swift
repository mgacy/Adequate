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
    private var appCoordinator: AppCoordinator!
    private var notificationServiceManager: NotificationServiceManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        log.debug("\(#function) - \(String(describing: launchOptions))")
        self.window = UIWindow(frame: UIScreen.main.bounds)

        UNUserNotificationCenter.current().delegate = self

        // Check if launched from notification
        let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
        let deepLink = DeepLink.build(with: notification)

        // TODO: create NotificationManager here and inject into AppCoordinator / create delegate protocol?
        self.appCoordinator = AppCoordinator(window: self.window!)
        self.appCoordinator.start(with: deepLink)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        log.verbose("WILL_RESIGN_ACTIVE")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        log.verbose("DID_ENTER_BACKGROUND")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        log.verbose("WILL_ENTER_FOREGROUND")

        // TODO: move all of this into `RefreshManager` object
        // TODO: handle case where background app refresh failed
        switch application.backgroundRefreshStatus {
        case .denied, .restricted:
            log.debug("backgroundRefreshStatus: \(application.backgroundRefreshStatus) - calling refreshDeal(showLoading:)")
            appCoordinator.refreshDeal(showLoading: false)
        case .available:
            // TESTING:
            //appCoordinator.refreshDeal(showLoading: false)
            break
        @unknown default:
            fatalError("Unknown UIBackgroundRefreshStatus: \(application.backgroundRefreshStatus)")
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        log.verbose("DID_BECOME_ACTIVE")
        //appCoordinator.refreshDeal()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        log.debug("WILL_TERMINATE")
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
        notificationServiceManager = AWSManager(region: .USWest2)
        notificationServiceManager?.registerDevice(with: token)
            .then({ [weak self] subscriptionArn in
                self?.notificationServiceManager = nil
            })
            .catch({error in
                log.error("ERROR: \(error)")
            })
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("Failed to register for remote notifications with error: \(error)")
    }

    // MARK: - Background App Refresh

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Called for silent notifications.
        log.debug("\(#function) - \(userInfo)")
        appCoordinator.refreshDealInBackground(completion: completionHandler)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        log.debug("\(#function)")
        // TODO: prepare for other `response.notification.request.content.categoryIdentifier`
        appCoordinator.refreshDeal(showLoading: true)

        completionHandler([.alert, .sound])
        //completionHandler(UNNotificationPresentationOptions(rawValue: 0))  // skip notification
    }

    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        log.debug("\(#function) - \(response)")
        let userInfo = response.notification.request.content.userInfo

        // TODO: prepare for other `response.notification.request.content.categoryIdentifier`
        switch response.actionIdentifier {
        case NotificationAction.buyAction.rawValue:
            if let urlString = userInfo[NotificationConstants.dealKey] as? String, let buyURL = URL(string: urlString) {
                appCoordinator.start(with: .buy(buyURL))
            } else {
                log.error("ERROR: unable to parse \(NotificationConstants.dealKey) from Notification")
            }
        case NotificationAction.shareAction.rawValue:
            if let urlString = userInfo[NotificationConstants.dealKey] as? String, let dealURL = URL(string: urlString)?.deletingLastPathComponent() {
                let title = response.notification.request.content.body
                appCoordinator.start(with: .share(title: title, url: dealURL))
            } else {
                log.error("ERROR: unable to parse \(NotificationConstants.dealKey) from Notification")
            }
        case UNNotificationDefaultActionIdentifier:
            // TODO: how to handle?
            log.info("\(#function) - DefaultActionIdentifier")
        case UNNotificationDismissActionIdentifier:
            // TODO: how to handle?
            log.info("\(#function) - DismissActionIdentifier")
        default:
            log.warning("\(#function) - unknown action: \(response.actionIdentifier)")
        }
        completionHandler()
    }

}
