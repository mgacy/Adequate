//
//  HistoryDetailCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/26/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import SafariServices
import Promise

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

    private func showWebPage(with url: URL, animated: Bool) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        router.present(viewController, animated: animated)
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

// MARK: - HistoryDetailViewControllerDelegate
extension HistoryDetailCoordinator: HistoryDetailViewControllerDelegate {
    func showImage(_ imageSource: Promise<UIImage>, animatingFrom originFrame: CGRect) {
        // ...
    }

    func showForum(with topic: Topic) {
        showWebPage(with: topic.url, animated: true)
    }
}

//// MARK: - SettingsViewControllerDelegate
//extension HistoryDetailCoordinator: SettingsViewControllerDelegate {
//    func dismiss(_ result: CoordinationResult) {
//        onFinishFlow?(result)
//    }
//}
