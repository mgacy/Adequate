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
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager & AppUsageCounterProvider

    private let dependencies: Dependencies

    var onPageSelect: ((RootViewControllerPage, RootViewControllerPage, Bool) -> Void)?

    // MARK: - Lifecycle

    init(router: RouterType, dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(router: router)
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            switch deepLink {
            case let .buy(url):
                showWebPage(with: url, animated: false)
            case .deal:
                router.dismissModule(animated: false, completion: nil)
            case let .share(title, url):
                shareDeal(title: title, url: url)
            default:
                log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
            }
        } else {
            showDeal()
        }
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showDeal() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            let dealViewController = DealViewController(dependencies: dependencies)
            dealViewController.delegate = self
            router.setRootModule(dealViewController, hideBar: false)
        case .pad, .carPlay:
            let dealViewController = DealViewController(dependencies: dependencies)
            dealViewController.delegate = self
            let splitViewController = SplitViewController(primaryChild: dealViewController)
            splitViewController.rotationManager = dealViewController
            router.setRootModule(splitViewController, hideBar: false)
        default:
            fatalError("Invalid device")
        }
    }

    private func shareDeal(title: String, url: URL) {
        //router.popToRootModule(animated: false) // not currently necessary
        guard let dealViewController = router.rootViewController as? DealViewController else {
            log.error("Unable to get dealViewController")
            return
        }
        router.dismissModule(animated: false, completion: nil)
        dealViewController.shareDeal(title: title, url: url)
    }

    private func showWebPage(with url: URL, animated: Bool, completion: (() -> Void)? = nil) {
        router.dismissModule(animated: false, completion: nil)
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        router.present(viewController, animated: animated, completion: completion)
    }

    private func openURL(_ url: URL, completion: ((Bool) -> Void)? = nil) {
        UIApplication.shared.open(url, completionHandler: completion)
    }

    private func showActivityViewController(_ activityViewController: UIActivityViewController) {
        router.present(activityViewController, animated: true) { [weak self] in
            if let counter = self?.dependencies.makeAppUsageCounter() {
                counter.userDid(perform: .shareDeal)
            }
        }
    }
}

// MARK: - FullScreenImagePresenting
extension DealCoordinator: FullScreenImagePresenting {}

// MARK: - DealViewControllerDelegate
extension DealCoordinator: DealViewControllerDelegate {

    func showHistoryList() {
        onPageSelect?(.history, .deal, true)
    }

    func showStory() {
        onPageSelect?(.story, .deal, true)
    }

    func showForum(with topic: Topic) {
        showWebPage(with: topic.url, animated: true)
    }

    func showPurchase(for deal: Deal) {
        let dealURL = deal.url.appendingPathComponent("checkout")
        // TODO: pass to PurchaseManager
        // show web page / open Safari
        showWebPage(with: dealURL, animated: true) { [weak self] in
            if let counter = self?.dependencies.makeAppUsageCounter() {
                counter.userDid(perform: .pressBuy)
            }
        }
    }

    func showShareSheet(activityItems: [Any], from sourceView: UIView) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        showActivityViewController(activityViewController)
    }

    func showShareSheet(activityItems: [Any], from barButtonItem: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = barButtonItem
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        showActivityViewController(activityViewController)
    }
}

// MARK: - FullScreenImageDelegate
extension DealCoordinator: FullScreenImageDelegate {
    func dismissFullScreenImage() {
        router.dismissModule(animated: true, completion: nil)
    }
}
