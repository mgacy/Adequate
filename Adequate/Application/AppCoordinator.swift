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
            log.debug("\(#function) - \(deepLink)")
            switch deepLink {
            case .onboarding:
                showOnboarding()
            case .remoteNotification(let payload):
                showMain(notificationPayload: payload)
            case .debug:
                showDebug()
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

    private func showOnboarding() {
        let coordinator = OnboardingCoordinator(window: window, dependencies: dependencies)
        coordinator.onFinishFlow = { [weak self, weak coordinator] result in
            if let strongCoordinator = coordinator {
                self?.free(coordinator: strongCoordinator)
            }
            self?.showMain()
        }
        store(coordinator: coordinator)
        coordinator.start()
    }

    private func showMain(notificationPayload payload: [String : AnyObject]? = nil) {
        let refreshEvent: RefreshEvent = payload != nil ? .launchFromNotification(payload!) : .launch
        refreshDeal(for: refreshEvent)
        let mainCoordinator = MainCoordinator(window: window, dependencies: dependencies)
        store(coordinator: mainCoordinator)
        mainCoordinator.start()
    }

    private func showDebug() {
        let coordinator = DebugCoordinator(window: window, dependencies: dependencies)
        coordinator.onFinishFlow = { [weak self, weak coordinator] result in
            if let strongCoordinator = coordinator {
                self?.free(coordinator: strongCoordinator)
            }
            self?.showMain()
        }
        store(coordinator: coordinator)
        coordinator.start()
    }
}

// MARK: - Refresh
extension AppCoordinator {
    typealias FetchCompletionHandler = (UIBackgroundFetchResult) -> Void

    func refreshDeal(for event: RefreshEvent) {
        dependencies.dataProvider.refreshDeal(for: event)
    }

    func updateDealInBackground(userInfo: [AnyHashable : Any], completion: @escaping FetchCompletionHandler) {
        let delta = DealDelta(userInfo: userInfo) ?? .newDeal
        dependencies.dataProvider.updateDealInBackground(delta, fetchCompletionHandler: completion)
    }
}
