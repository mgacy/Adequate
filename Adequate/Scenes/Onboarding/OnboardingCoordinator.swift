//
//  OnboardingCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/25/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class OnboardingCoordinator: BaseCoordinator {
    typealias CoordinationResult = Void
    typealias Dependencies = HasNotificationManager & HasUserDefaultsManager

    private let window: UIWindow
    private let dependencies: Dependencies
    private let router: RouterType

    var onFinishFlow: ((CoordinationResult) -> Void)?

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
        self.router = Router(navigationController: UINavigationController())
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

        router.setRootModule(viewController, hideBar: true)
        window.rootViewController = router.toPresent()
        window.makeKeyAndVisible()
    }

}

// MARK: - Presentable
extension OnboardingCoordinator: Presentable {
    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}

// MARK: - VoidDismissalDelegate
extension OnboardingCoordinator: VoidDismissalDelegate {
    func dismiss() {
        onFinishFlow?(())
    }
}
