//
//  AppCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// swiftlint:disable:next private_over_fileprivate
fileprivate enum LaunchInstructor {
    case onboarding
    case main

    static func configure(with userDefaultsManager: UserDefaultsManagerType) -> LaunchInstructor {
        switch userDefaultsManager.hasShownOnboarding {
        case true:
            return .main
        case false:
            return .onboarding
        }
    }

}

protocol AppCoordinating: CoordinatorType {
    func refreshDeal(for event: RefreshEvent)
    func registerForPushNotifications(with manager: NotificationManagerType)
}

class AppCoordinator: BaseCoordinator, AppCoordinating {

    private let window: UIWindow
    private let dependencies: AppDependency

    private var notificationManager: NotificationManagerType?

    init(window: UIWindow, dependencies: AppDependency) {
        self.window = window
        self.dependencies = dependencies
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            log.debug("\(#function) - \(deepLink)")
            switch deepLink {
            case .onboarding:
                showOnboarding()
                return
            case .remoteNotification(let notification):
                showMain(dealNotification: notification)
                // Apple suggests registering for notifications each time app launches because the token will change if
                // the user restores backup data to a new device or reinstalls OS. If we are receiving remote
                // notifications, that isn't an issue.
                return
            case .debug:
                showDebug()
            default:
                startChildren(with: deepLink)
            }
        } else {
            switch LaunchInstructor.configure(with: dependencies.userDefaultsManager) {
            case .onboarding:
                // TODO: record initial launch
                showOnboarding()
                return
            case .main:
                showMain()
                let counter = dependencies.makeAppUsageCounter()
                counter.userDid(perform: .launchApp)
            }
        }

        if dependencies.userDefaultsManager.showNotifications {
            registerForPushNotifications(with: dependencies.makeNotificationManager())
        }
    }

    // MARK: - Flows

    private func showOnboarding() {
        let coordinator = OnboardingCoordinator(window: window, dependencies: dependencies)
        coordinator.onFinishFlow = { [weak self, weak coordinator] result in
            if case .allowNotifications(let manager) = result {
                self?.registerForPushNotifications(with: manager)
            }
            if let strongCoordinator = coordinator {
                self?.free(coordinator: strongCoordinator)
            }
            self?.showMain()
        }
        store(coordinator: coordinator)
        coordinator.start()
    }

    private func showMain(dealNotification: DealNotification? = nil) {
        let refreshEvent: RefreshEvent = dealNotification != nil ? .launchFromNotification(dealNotification!) : .launch
        // On iOS 13, `AppDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)` does not seem to
        // be called when app launches in response to notification, so go ahead and call `refreshDeal(for:)` now,
        // regardless of whether we would be passing `RefreshEvent.launch` or `.launchFromNotification`.
        refreshDeal(for: refreshEvent)
        let mainCoordinator = MainCoordinator(window: window, dependencies: dependencies)
        store(coordinator: mainCoordinator)
        mainCoordinator.start()
    }

    private func showDebug() {
        if case .production = Configuration.environment {
            showMain()
            return
        }
        let coordinator = DebugCoordinator(window: window, dependencies: dependencies)
        coordinator.onFinishFlow = { [weak self, weak coordinator] _ in
            if let strongCoordinator = coordinator {
                self?.free(coordinator: strongCoordinator)
            }
            self?.showMain()
        }
        store(coordinator: coordinator)
        coordinator.start()
    }
}

// TODO: consider moving these into an `AppController` object

// MARK: - Refresh
extension AppCoordinator {

    func refreshDeal(for event: RefreshEvent) {
        dependencies.dataProvider.refreshDeal(for: event)
    }
}

// MARK: - Notifications
extension AppCoordinator {

    func registerForPushNotifications(with manager: NotificationManagerType) {
        notificationManager = manager
        notificationManager?.registerForPushNotifications()
            .then({
                log.verbose("Registered for notifications")
            })
            .catch({ error in
                log.error("Unable to register for push notifications: \(error)")
            })
            .always {
                self.notificationManager = nil
            }
    }
}

// MARK: - Testing
class TestAppCoordinator: BaseCoordinator, AppCoordinating {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start(with: DeepLink?) {
        start()
    }

    override func start() {
        let viewController = UIViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    // MARK: - AppCoordinating

    func refreshDeal(for event: RefreshEvent) {}

    func registerForPushNotifications(with manager: NotificationManagerType) {}
}
