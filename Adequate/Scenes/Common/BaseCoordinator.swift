//
//  BaseCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import UserNotifications

// MARK: - DeepLink

struct DeepLinkURLConstants {
    static let deal = "deal"
    static let onboarding = "onboarding"
}

enum DeepLink {
    /// Show onboarding scene.
    case onboarding
    /// Respond to launch from remote notification.
    case remoteNotification([String : AnyObject])
    /// Show current deal scene.
    case deal
    /// Show purchase page for current deal.
    case buy(URL)
    /// Show share sheet from current deal scene.
    case share(title: String, url: URL)

    static func build(with dict: [String: AnyObject]?) -> DeepLink? {
        guard let id = dict?["launch_id"] as? String else { return nil }

        switch id {
        case DeepLinkURLConstants.onboarding: return .onboarding
        default: return nil
        }
    }

    static func build(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> DeepLink? {
        guard let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] else {
            return nil
        }
        // TODO: perform any further verifications of structure?
        return .remoteNotification(notification)
    }

    static func build(with url: URL) -> DeepLink? {
        switch url.host {
        case DeepLinkURLConstants.deal: return .deal
        default: return nil
        }
    }

    static func build(with userActivity: NSUserActivity) -> DeepLink? {
        return nil
    }

    static func build(with notificationResponse: UNNotificationResponse) -> DeepLink? {
        let userInfo = notificationResponse.notification.request.content.userInfo
        switch notificationResponse.notification.request.content.categoryIdentifier {

        // dailyDeal
        case NotificationCategoryIdentifier.dailyDeal.rawValue:
            switch notificationResponse.actionIdentifier {
            case NotificationAction.buyAction.rawValue:
                guard
                    let urlString = userInfo[NotificationConstants.dealKey] as? String,
                    let buyURL = URL(string: urlString) else {
                        log.error("ERROR: unable to parse \(NotificationConstants.dealKey) from Notification")
                        return nil
                }
                return .buy(buyURL)
            case NotificationAction.shareAction.rawValue:
                guard
                    let urlString = userInfo[NotificationConstants.dealKey] as? String,
                    let dealURL = URL(string: urlString)?.deletingLastPathComponent() else {
                        log.error("ERROR: unable to parse \(NotificationConstants.dealKey) from Notification")
                        return nil
                }
                let title = notificationResponse.notification.request.content.body
                return .share(title: title, url: dealURL)
            case UNNotificationDefaultActionIdentifier:
                log.info("\(#function) - DefaultActionIdentifier")
                return deal
            case UNNotificationDismissActionIdentifier:
                // TODO: how to handle?
                log.info("\(#function) - DismissActionIdentifier")
                return nil
            default:
                log.warning("\(#function) - unknown action: \(notificationResponse.actionIdentifier)")
                return nil
            }
        default:
            let categoryID = notificationResponse.notification.request.content.categoryIdentifier
            log.warning("\(#function) - unknown category: \(categoryID)")
            return nil
        }
    }

}

// MARK: - Protocol

protocol CoordinatorType: class {
    //associatedtype CoordinationResult
    //associatedtype Transition
    //associatedtype Scene
    var identifier: UUID { get }
    func start()
    func start(with: DeepLink?)
}

// MARK: - Base Class

class BaseCoordinator: NSObject, CoordinatorType {

    /// Unique identifier.
    internal let identifier = UUID()

    private var childCoordinators = [UUID: CoordinatorType]()

    func store(coordinator: CoordinatorType) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    // TODO: accept optional to avoid weak/strong dance in onFinishFlow
    func free(coordinator: CoordinatorType) {
        // TODO: recursively free children coordinators?
        childCoordinators[coordinator.identifier] = nil
    }

    // MARK: A

    public func start() {
        start(with: nil)
    }

    public func start(with deepLink: DeepLink?) {
        // ...
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

}

// MARK: - Helper Methods
extension BaseCoordinator {

    public func coordinate(to coordinator: CoordinatorType) {
        store(coordinator: coordinator)
        coordinator.start()
    }

    public func coordinate(to coordinator: CoordinatorType, with deepLink: DeepLink? = nil) {
        // TODO: set onFinishFlow on coordinator
        store(coordinator: coordinator)
        coordinator.start(with: deepLink)
    }

    public func startChildren(with deepLink: DeepLink) {
        childCoordinators.forEach { $1.start(with: deepLink) }
    }

}

// MARK: - Coordinator
class Coordinator: BaseCoordinator {
    let router: RouterType

    init(router: RouterType) {
        self.router = router
    }
}

extension Coordinator: Presentable {
    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}
