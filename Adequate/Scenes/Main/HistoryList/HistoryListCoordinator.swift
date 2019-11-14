//
//  HistoryListCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class HistoryListCoordinator: Coordinator {
    typealias Dependencies = HasDataProvider & HasImageService & HasNotificationManager & HasThemeManager & HasUserDefaultsManager
    typealias DealFragment = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    private let dependencies: Dependencies

    var onPageSelect: ((RootViewControllerPage, RootViewControllerPage, Bool) -> Void)?

    // MARK: - Lifecycle

    init(router: RouterType, dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(router: router)
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            // TODO: just call `startChildren(with:)` for all cases?
            switch deepLink {
            case .buy, .deal, .share:
                startChildren(with: deepLink)
            default:
                log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
            }
        } else {
            showHistory()
        }
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showHistory() {
        let historyListViewController = HistoryListViewController(dependencies: dependencies)
        historyListViewController.delegate = self
        router.setRootModule(historyListViewController, hideBar: false)
    }

}

// MARK: - HistoryListViewControllerDelegate
extension HistoryListCoordinator: HistoryListViewControllerDelegate {

    func showDeal() {
        onPageSelect?(.deal, .history, true)
    }

    func showHistoryDetail(with deal: DealFragment) {
        let detailRouter = Router()
        let coordinator = HistoryDetailCoordinator(router: detailRouter, dependencies: dependencies, deal: deal)
        coordinator.onFinishFlow = { [weak self, weak coordinator] _ in
            self?.router.dismissModule(animated: true, completion: nil)
            if let strongCoordinator = coordinator {
                self?.free(coordinator: strongCoordinator)
            }
        }
        coordinate(to: coordinator)
        router.present(coordinator, animated: true)
    }

    func showSettings() {
        let navigationController = UINavigationController()
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController.modalPresentationStyle = .formSheet
        }
        let settingsRouter = Router(navigationController: navigationController)
        let coordinator = SettingsCoordinator(router: settingsRouter, dependencies: dependencies)
        coordinator.onFinishFlow = { [weak self, weak coordinator] _ in
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
/*
// MARK: - VoidDismissalDelegate
extension HistoryListCoordinator: VoidDismissalDelegate {

    func dismiss() {
        router.dismissModule(animated: true, completion: nil)
    }

}
*/
