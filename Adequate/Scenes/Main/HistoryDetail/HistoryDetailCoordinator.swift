//
//  HistoryDetailCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/26/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class HistoryDetailCoordinator: BaseCoordinator {
    typealias CoordinationResult = Void
    typealias Dependencies = HasDataProvider & HasThemeManager

    private let router: RouterType
    private let dependencies: Dependencies
    private let deal: Deal

    var onFinishFlow: ((CoordinationResult) -> Void)? = nil

    // MARK: - Lifecycle

    init(router: RouterType, dependencies: Dependencies, deal: Deal) {
        self.router = router
        self.dependencies = dependencies
        self.deal = deal
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            print("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
            startChildren(with: deepLink)
        } else {
            showDetail()
        }
    }

    deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showDetail() {
        let viewController = HistoryDetailViewController(dependencies: dependencies, deal: deal)
        viewController.delegate = self
        router.setRootModule(viewController, hideBar: false)
    }

}

// MARK: - Presentable
extension HistoryDetailCoordinator: Presentable {
    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}

// MARK: - VoidDismissalDelegate
extension HistoryDetailCoordinator: VoidDismissalDelegate {
    func dismiss() {
        onFinishFlow?(())
    }
}

//// MARK: - SettingsViewControllerDelegate
//extension HistoryDetailCoordinator: SettingsViewControllerDelegate {
//    func dismiss(_ result: CoordinationResult) {
//        onFinishFlow?(result)
//    }
//}
