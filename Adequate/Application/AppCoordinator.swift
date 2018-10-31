//
//  AppCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {

    private let window: UIWindow
    private let dependencies: AppDependency

    init(window: UIWindow) {
        self.window = window
        self.dependencies = AppDependency()
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            switch deepLink {
            case .onboarding:
                showOnboarding()
            default:
                startChildren(with: deepLink)
            }
        } else {
            /// TODO: use LaunchInstructor
            showMain()
        }
    }

    // MARK: - Flows

    private func showOnboarding(with deepLink: DeepLink? = nil) {
        let coordinator = OnboardingCoordinator(window: window, dependencies: dependencies)
        coordinator.onFinishFlow = { [weak self, weak coordinator] result in
            if let strongCoordinator = coordinator {
                self?.free(coordinator: strongCoordinator)
            }
            self?.showMain()
        }
        store(coordinator: coordinator)
        coordinator.start(with: deepLink)
    }

    private func showMain(with deepLink: DeepLink? = nil) {
        let mainCoordinator = MainCoordinator(window: window, dependencies: dependencies)
        store(coordinator: mainCoordinator)
        mainCoordinator.start(with: deepLink)
    }

}
