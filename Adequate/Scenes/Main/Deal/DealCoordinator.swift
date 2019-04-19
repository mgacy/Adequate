//
//  DealCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import SafariServices
import Promise

final class DealCoordinator: Coordinator {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager

    private let dependencies: Dependencies

    var onPageSelect: ((RootViewControllerPage, RootViewControllerPage, Bool) -> Void)?

    // MARK: - Lifecycle

    init(router: RouterType, dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(router: router)
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
        } else {
            showDeal()
        }
    }

    deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showDeal() {
        let dealViewController = DealViewController(dependencies: dependencies)
        dealViewController.delegate = self
        router.setRootModule(dealViewController, hideBar: false)
    }

    private func showWebPage(with url: URL, animated: Bool) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        router.present(viewController, animated: animated)
    }

}

// MARK: - DealViewControllerDelegate
extension DealCoordinator: DealViewControllerDelegate {

    func showHistoryList() {
        //delegate?.goToPage(.history, from: .deal, animated: true)
        onPageSelect?(.history, .deal, true)
    }

    func showStory() {
        //delegate?.goToPage(.story, from: .deal, animated: true)
        onPageSelect?(.story, .deal, true)
    }

    func showForum(with topic: Topic) {
        showWebPage(with: topic.url, animated: true)
    }

    func showImage(animatingFrom pagedImageView: PagedImageView) {
        let viewController = FullScreenImageViewController(imageSource: pagedImageView.visibleImage)
        viewController.delegate = self
        viewController.setupTransitionController(animatingFrom: pagedImageView)
        router.present(viewController, animated: true)
    }

    func showPurchase(for deal: Deal) {
        let dealURL = deal.url.appendingPathComponent("checkout")
        showWebPage(with: dealURL, animated: true)
    }

}

// MARK: - FullScreenImageDelegate
extension DealCoordinator: FullScreenImageDelegate {
    func dismissFullScreenImage() {
        router.dismissModule(animated: true, completion: nil)
    }
}
