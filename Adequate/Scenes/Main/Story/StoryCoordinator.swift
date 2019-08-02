//
//  StoryCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class StoryCoordinator: Coordinator {
    typealias Dependencies = HasDataProvider & HasThemeManager

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
            showStory()
        }
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - Private Methods

    private func showStory() {
        let storyViewController = StoryViewController(depenedencies: dependencies)
        storyViewController.delegate = self
        router.setRootModule(storyViewController, hideBar: false)
    }

}

// MARK: - StoryVIewControllerDelegate
extension StoryCoordinator: StoryViewControllerDelegate {
    func showDeal() {
        onPageSelect?(.deal, .story, true)
    }
}
