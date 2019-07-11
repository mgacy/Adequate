//
//  AppCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

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
            case .deal:
                showMain(with: deepLink)
            case .share:
                startChildren(with: deepLink)
            default:
                startChildren(with: deepLink)
            }
        } else {
            switch LaunchInstructor.configure(with: dependencies.userDefaultsManager) {
            case .onboarding:
                showOnboarding()
            case .main:
                showMain()
            }
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

// MARK: - Refresh
extension AppCoordinator {
    typealias FetchCompletionHandler = (UIBackgroundFetchResult) -> Void

    func refreshDeal(showLoading: Bool) {
        dependencies.dataProvider.refreshDeal(showLoading: showLoading)
    }

    func refreshDealInBackground(userInfo: [AnyHashable : Any], completion: @escaping FetchCompletionHandler) {
        dependencies.dataProvider.refreshDealInBackground(fetchCompletionHandler: completion)
    }
}
