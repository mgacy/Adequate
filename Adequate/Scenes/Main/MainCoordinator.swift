//
//  MainCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import SafariServices

final class MainCoordinator: BaseCoordinator {
    typealias Dependencies = HasDataProvider & HasImageService & HasNotificationManager & HasThemeManager & HasUserDefaultsManager

    private let window: UIWindow
    private let dependencies: Dependencies
    private let pageViewController: RootPageViewControler

    // MARK: Page Coordinators

    lazy var historyCoordinator: HistoryListCoordinator = {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        let coordinator = HistoryListCoordinator(router: router, dependencies: dependencies)
        coordinator.onPageSelect = { [weak self] destination, source, animated in
            self?.goToPage(destination, from: source, animated: animated)
        }
        return coordinator
    }()

    lazy var dealCoordinator: DealCoordinator = {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        let coordinator = DealCoordinator(router: router, dependencies: dependencies)
        coordinator.onPageSelect = { [weak self] destination, source, animated in
            self?.goToPage(destination, from: source, animated: animated)
        }
        return coordinator
    }()

    lazy var storyCoordinator: StoryCoordinator = {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        let coordinator = StoryCoordinator(router: router, dependencies: dependencies)
        coordinator.onPageSelect = { [weak self] destination, source, animated in
            self?.goToPage(destination, from: source, animated: animated)
        }
        return coordinator
    }()

    // MARK: - Lifecycle

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
        self.pageViewController = RootPageViewControler(depenedencies: dependencies)
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            switch deepLink {
            case .buy(let url):
                pageViewController.dismiss(animated: false, completion: nil)
                // TODO: go to deal page?
                showWebPage(with: url, animated: false)
            case .deal:
                showDeal()
            //case .meh:
            //    log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
            case .share:
                // TODO: improve handling
                switch pageViewController.currentIndex {
                case 0:
                    goToPage(.deal, from: .history, animated: false)
                case 2:
                    goToPage(.deal, from: .story, animated: false)
                default:
                    break
                }
                startChildren(with: deepLink)
            default:
                log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
                startChildren(with: deepLink)
            }
        } else {
            showDeal()
        }
    }

    deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func setPages(_ coordinators: [Coordinator], animated: Bool = false) {
        let vcs = coordinators.map { coordinator -> UIViewController in
            self.coordinate(to: coordinator)
            return coordinator.toPresent()
        }
        pageViewController.setPages(vcs, displayIndex: 1, animated: animated)
    }

    private func showDeal() {
        setPages([historyCoordinator, dealCoordinator, storyCoordinator], animated: false)
        window.rootViewController = pageViewController
        window.makeKeyAndVisible()
    }

    private func showWebPage(with url: URL, animated: Bool) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        pageViewController.present(viewController, animated: animated, completion: nil)
    }

}

// MARK: - RootNavigationDelegate
extension MainCoordinator {
    func goToPage(_ destination: RootViewControllerPage, from source: RootViewControllerPage, animated: Bool = true) {

        /* Alternatively, we could:
         * - let currentVC  = pageViewController.viewControllers?.first
         * - (cast as type conforming to protocol with .rootPage: RootViewControllerPage)?
         * - let currentIndex = pages.index(of: currentVC)
         *
         * also, source could be a property of router or UIPageViewController subclass
         */

        switch (source, destination) {
        case (.history, .deal):
            pageViewController.goToNextPage(animated: animated)
        case (.deal, .history):
            pageViewController.goToPreviousPage(animated: animated)
        case (.deal, .story):
            pageViewController.goToNextPage(animated: animated)
        case (.story, .deal):
            pageViewController.goToPreviousPage(animated: animated)
        default:
            fatalError("Invalid transition between root page view controller pages.")
        }
    }
}

// MARK: - Presentable
extension MainCoordinator: Presentable {
    func toPresent() -> UIViewController {
        return pageViewController
    }
}

