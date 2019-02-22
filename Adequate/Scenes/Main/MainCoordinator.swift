//
//  MainCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import SafariServices
import Promise

class MainCoordinator: BaseCoordinator {
    typealias Dependencies = HasClient & HasMehService & HasNotificationManager & HasThemeManager & HasUserDefaultsManager

    private let window: UIWindow
    private let dependencies: Dependencies
    private let router: RouterType

    // MARK: - Lifecycle

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
        self.router = Router(navigationController: UINavigationController())
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            switch deepLink {
            case .buy(let url):
                router.dismissModule(animated: false, completion: nil)
                router.popToRootModule(animated: false)
                showWebPage(with: url, animated: false)
            case .deal:
                showDeal()
            case .meh:
                print("DeepLink: meh")
            default:
                print("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
                startChildren(with: deepLink)
            }
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
        //router.setRootModule(dealViewController, hideBar: true)
        window.rootViewController = router.toPresent()
        window.makeKeyAndVisible()
    }

    private func showWebPage(with url: URL, animated: Bool) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        router.present(viewController, animated: animated)
    }

}

// MARK: - DealViewControllerDelegate
extension MainCoordinator: DealViewControllerDelegate {

    func showImage(_ imageSource: Promise<UIImage>, animatingFrom originFrame: CGRect) {
        let viewController = FullScreenImageViewController(imageSource: imageSource, originFrame: originFrame)
        viewController.delegate = self
        router.present(viewController, animated: true)
    }

    func showPurchase(for deal: Deal) {
        let dealURL = deal.url.appendingPathComponent("checkout")
        showWebPage(with: dealURL, animated: true)
    }

    func showStory(with story: Story) {
        let viewController = StoryViewController(story: story, depenedencies: dependencies)
        router.push(viewController, animated: true, completion: nil)
    }

    func showForum(with topic: Topic) {
        showWebPage(with: topic.url, animated: true)
    }

    @objc func showSettings() {
        let settingsRouter = Router()
        let coordinator = SettingsCoordinator(router: settingsRouter, dependencies: dependencies)
        coordinator.onFinishFlow = { [weak self, weak coordinator] result in
            self?.router.dismissModule(animated: true, completion: nil)
            if let strongCoordinator = coordinator {
                self?.free(coordinator: strongCoordinator)
            }
        }

        store(coordinator: coordinator)
        router.present(coordinator, animated: true)
        coordinator.start()
    }

    func showHistoryList() {
        let viewController = HistoryViewController(dependencies: dependencies)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        router.present(navigationController, animated: true)
    }

}

extension MainCoordinator: FullScreenImageDelegate {

    func dismissFullScreenImage() {
        router.dismissModule(animated: true, completion: nil)
    }

}

// MARK: - VoidDismissalDelegate
extension MainCoordinator: VoidDismissalDelegate {

    func dismiss() {
        router.dismissModule(animated: true, completion: nil)
    }

}
