//
//  SettingsCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class SettingsCoordinator: BaseCoordinator {
    typealias CoordinationResult = Void
    typealias Dependencies = HasNotificationManager & HasThemeManager & HasUserDefaultsManager

    private let router: RouterType
    private let dependencies: Dependencies

    var onFinishFlow: ((CoordinationResult) -> Void)? = nil

    init(router: RouterType, dependencies: Dependencies) {
        self.dependencies = dependencies
        self.router = router
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            print("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
            startChildren(with: deepLink)
        } else {
            let viewController = SettingsViewController(dependencies: dependencies)
            viewController.delegate = self
            router.setRootModule(viewController, hideBar: false)
        }
    }

    deinit { print("\(#function) - \(String(describing: self))") }

}

// MARK: - Presentable
extension SettingsCoordinator: Presentable {
    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}

// MARK: - SettingsViewControllerDelegate
extension SettingsCoordinator: SettingsViewControllerDelegate {
    func dismiss(_ result: CoordinationResult) {
        onFinishFlow?(result)
    }
}
