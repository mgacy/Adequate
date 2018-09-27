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
    typealias Dependencies = HasClient & HasMehService

    private let window: UIWindow
    private let dependencies: Dependencies
    private let router: RouterType

    // MARK: - Lifecycle

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
        self.router = Router(navigationController: UINavigationController())
    }

    override func start() {
        let dealViewController = DealViewController(dependencies: dependencies)
        dealViewController.delegate = self

        router.setRootModule(dealViewController, hideBar: true)
        window.rootViewController = router.toPresent()
        window.makeKeyAndVisible()
    }

    deinit { print("\(#function) - \(String(describing: self))") }

}

// MARK: - DealViewControllerDelegate
extension MainCoordinator: DealViewControllerDelegate {

    func showWebPage(with url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        router.present(viewController, animated: true)
    }

    func showImage(with imageSource: Promise<UIImage>) {
        // ...
    }

    func showPurchase(for deal: Deal) {
        let dealURL = deal.url.appendingPathComponent("checkout")
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = true

        let viewController = SFSafariViewController(url: dealURL, configuration: configuration)
        router.present(viewController, animated: true)
    }

    func showStory(with story: Story) {
        // ...
    }

    func showForum(_ url: URL) {
        // ...
    }

    @objc func showSettings() {
        // ...
    }

}
