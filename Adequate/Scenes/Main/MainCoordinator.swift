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
    typealias Dependencies = HasClient & HasMehService & HasNotificationManager

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
        let dealViewController = DealViewController(dependencies: dependencies)
        dealViewController.delegate = self

        router.setRootModule(dealViewController, hideBar: true)
        window.rootViewController = router.toPresent()
        window.makeKeyAndVisible()

        if let option = deepLink {
            switch option {
            case .buy(let url):
                showWebPage(with: url, animated: false)
            case .meh:
                print("DeepLink: meh")
            default:
                print("ERROR: invalid DeepLink")
            }
        }
    }

    deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    func showWebPage(with url: URL, animated: Bool) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        router.present(viewController, animated: animated)
    }

}

// MARK: - DealViewControllerDelegate
extension MainCoordinator: DealViewControllerDelegate {

    func showImage(with imageSource: Promise<UIImage>) {
        // ...
    }

    func showPurchase(for deal: Deal) {
        let dealURL = deal.url.appendingPathComponent("checkout")
        showWebPage(with: dealURL, animated: true)
    }

    func showStory(with story: Story) {
        let viewController = StoryViewController(story: story)
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

}
