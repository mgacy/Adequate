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
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod
    typealias Topic = GetDealQuery.Data.GetDeal.Topic

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
            switch deepLink {
            case .buy, .share:
                onFinishFlow?(())
            default:
                log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
                startChildren(with: deepLink)
            }
        } else {
            showDetail()
        }
    }

    deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showDetail() {
        let viewController = HistoryDetailViewController(dependencies: dependencies, deal: deal)
        viewController.delegate = self
        router.setRootModule(viewController, navBarStyle: .hiddenSeparator)
        viewController.attachTransitionController() { [weak self] in self?.onFinishFlow?(()) }
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
    func showImage(animatingFrom pagedImageView: PagedImageView) {
        let viewController = FullScreenImageViewController(imageSource: pagedImageView.visibleImage)
        viewController.delegate = self
        viewController.setupTransitionController(animatingFrom: pagedImageView)
        router.present(viewController, animated: true)
    }

    func showForum(with topic: Topic) {
        guard let topicURL = URL(string: topic.url) else {
            return
        }
        showWebPage(with: topicURL, animated: true)
    }
}

// MARK: - FullScreenImageDelegate
extension HistoryDetailCoordinator: FullScreenImageDelegate {
    func dismissFullScreenImage() {
        router.dismissModule(animated: true, completion: nil)
    }
}

//// MARK: - SettingsViewControllerDelegate
//extension HistoryDetailCoordinator: SettingsViewControllerDelegate {
//    func dismiss(_ result: CoordinationResult) {
//        onFinishFlow?(result)
//    }
//}
