//
//  DebugCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class DebugCoordinator: BaseCoordinator {
    typealias CoordinationResult = Void
    typealias Dependencies = AppDependency

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
            startChildren(with: deepLink)
        } else {
            showDebug()
        }
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showDebug() {
        let viewController = DebugViewController(dependencies: dependencies)
        viewController.dismissalDelegate = self
        router.setRootModule(viewController, hideBar: false)
        window.rootViewController = router.toPresent()
        window.makeKeyAndVisible()
    }

}

// MARK: - Presentable
extension DebugCoordinator: Presentable {
    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}

// MARK: - VoidDismissalDelegate
extension DebugCoordinator: VoidDismissalDelegate {
    func dismiss() {
        onFinishFlow?(())
    }
}

