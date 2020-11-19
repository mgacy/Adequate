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

final class HistoryDetailCoordinator: FinishableCoordinator<Void> {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager
    typealias Deal = DealHistoryQuery.Data.DealHistory.Item
    typealias Topic = GetDealQuery.Data.GetDeal.Topic

    private let dependencies: Dependencies
    private let deal: Deal

    // MARK: - Lifecycle

    init(router: RouterType, dependencies: Dependencies, deal: Deal) {
        self.dependencies = dependencies
        self.deal = deal
        super.init(router: router)
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            switch deepLink {
            case .buy, .deal, .share:
                onFinishFlow?(())
            default:
                log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
                startChildren(with: deepLink)
            }
        } else {
            showDetail()
        }
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showDetail() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            let viewController = HistoryDetailViewController(dependencies: dependencies, deal: deal)
            viewController.delegate = self
            router.setRootModule(viewController, hideBar: false)

            router.toPresent().presentationController?.delegate = self
        case .pad, .carPlay:
            let viewController = PadHistoryDetailViewController(dependencies: dependencies, deal: deal)
            viewController.delegate = self
            router.setRootModule(viewController, hideBar: false)

            router.toPresent().presentationController?.delegate = self
        default:
            fatalError("Invalid device")
        }
    }

    private func showWebPage(with url: URL, animated: Bool) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        router.present(viewController, animated: animated)
    }

}

// MARK: - UIAdaptivePresentationControllerDelegate
extension HistoryDetailCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onFinishFlow?(())
    }
}

// MARK: - FullScreenImagePresenting
extension HistoryDetailCoordinator: FullScreenImagePresenting {}

// MARK: - HistoryDetailViewControllerDelegate
extension HistoryDetailCoordinator: HistoryDetailViewControllerDelegate {

    func showForum(with topic: TopicType) {
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
