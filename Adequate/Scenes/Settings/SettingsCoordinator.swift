//
//  SettingsCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import SafariServices

final class SettingsCoordinator: FinishableCoordinator<Void> {
    typealias Dependencies = HasUserDefaultsManager & HasThemeManager & NotificationManagerProvider

    private let dependencies: Dependencies

    init(router: RouterType, dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(router: router)
    }

    override func start(with deepLink: DeepLink?) {
        if let deepLink = deepLink {
            log.debug("\(String(describing: self)) is unable to handle DeepLink: \(deepLink)")
            startChildren(with: deepLink)
        } else {
            let viewController = SettingsViewController(dependencies: dependencies)
            viewController.delegate = self
            router.setRootModule(viewController, hideBar: false)
        }
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

}

// MARK: - SettingsViewControllerDelegate
extension SettingsCoordinator: SettingsViewControllerDelegate {

    func showAppIcon() {
        let viewController = AppIconViewController()
        router.push(viewController, animated: true, completion: nil)
    }

    func showTheme() {
        let viewController = ThemeViewController(dependencies: dependencies)
        router.push(viewController, animated: true, completion: nil)
    }

    func showAbout() {
        let viewController = AboutViewController()
        viewController.delegate = self
        router.push(viewController, animated: true, completion: nil)
    }

    func showReview() {
        var components = URLComponents(string: Constants.baseReviewURLString)
        components?.path = "/app/id\(Constants.appID)"
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]

        guard let writeReviewURL = components?.url else {
            return
        }
        UIApplication.shared.open(writeReviewURL)
    }

}

// MARK: - AboutViewControllerDelegate
extension SettingsCoordinator: AboutViewControllerDelegate {

    func showAcknowledgements() {
        let viewController = AcknowledgementsViewController(dependencies: dependencies)
        router.push(viewController, animated: true, completion: nil)
    }

    func showPrivacyPolicy() {
        let privacyPolicyURL = URL(string: Constants.privacyPolicyURLString)!

        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: privacyPolicyURL, configuration: configuration)
        router.present(viewController, animated: true)
    }

}

// TODO: Move to better location
extension SettingsCoordinator {
    private enum Constants {
        static let privacyPolicyURLString = "https://mgacy.github.io/Adequate/privacy"
        static let baseReviewURLString = "https://apps.apple.com"
        static let appID = "1438986355"
    }
}
