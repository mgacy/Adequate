//
//  OnboardingCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/25/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - ResultType
enum OnboardingResult {
    /// User opted to allow notifications and provided authorization.
    case allowNotifications(NotificationManagerType)
    // User tapped "OK" but then denied authorization to show notifications.
    //case disallowNotifications
    /// User opted not to allow notifications.
    case noNotifications
    // User opted to allow notifications but aurhorization failed with an error.
    //case authRequestError(Error)
}

// MARK: - Coordinator
final class OnboardingCoordinator: FinishableCoordinator<OnboardingResult> {
    typealias Dependencies = HasUserDefaultsManager & NotificationManagerProvider

    private let window: UIWindow
    private let dependencies: Dependencies

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
        super.init(router: Router())
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
            startChildren(with: deepLink)
        } else {
            showOnboarding()
        }
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showOnboarding() {
        let viewController = OnboardingPageViewController(dependencies: dependencies)
        viewController.dismissalDelegate = self
        router.setRootModule(viewController, hideBar: true)
        window.rootViewController = router.toPresent()
        window.makeKeyAndVisible()
    }

}

// MARK: - OnboardingDismissalDelegate
extension OnboardingCoordinator: OnboardingDismissalDelegate {}
