//
//  BaseCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - DeepLink

struct DeepLinkURLConstants {
    static let deal = "deal"
    static let onboarding = "onboarding"
}

enum DeepLink {
    case onboarding
    case deal
    case buy(URL)
    case share(title: String, url: URL)
    case meh

    static func build(with dict: [String: AnyObject]?) -> DeepLink? {
        guard let id = dict?["launch_id"] as? String else { return nil }

        switch id {
        case DeepLinkURLConstants.onboarding: return .onboarding
        default: return nil
        }
    }

    static func build(with url: URL) -> DeepLink? {
        switch url.host {
        case DeepLinkURLConstants.deal: return .deal
        default: return nil
        }
    }

    static func build(with userActivity: NSUserActivity) -> DeepLink? {
        return nil
    }

    //static func build(with notificationResponse: import UserNotifications) -> DeepLink? {}

}

// MARK: - Protocol

protocol CoordinatorType: class {
    //associatedtype CoordinationResult
    //associatedtype Transition
    //associatedtype Scene
    var identifier: UUID { get }
    func start()
    func start(with: DeepLink?)
}

// MARK: - Base Class

class BaseCoordinator: NSObject, CoordinatorType {

    /// Unique identifier.
    internal let identifier = UUID()

    private var childCoordinators = [UUID: CoordinatorType]()

    func store(coordinator: CoordinatorType) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    // TODO: accept optional to avoid weak/strong dance in onFinishFlow
    func free(coordinator: CoordinatorType) {
        // TODO: recursively free children coordinators?
        childCoordinators[coordinator.identifier] = nil
    }

    // MARK: A

    public func start() {
        start(with: nil)
    }

    public func start(with deepLink: DeepLink?) {
        // ...
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

}

// MARK: - Helper Methods
extension BaseCoordinator {

    public func coordinate(to coordinator: CoordinatorType) {
        store(coordinator: coordinator)
        coordinator.start()
    }

    public func coordinate(to coordinator: CoordinatorType, with deepLink: DeepLink? = nil) {
        // TODO: set onFinishFlow on coordinator
        store(coordinator: coordinator)
        coordinator.start(with: deepLink)
    }

    public func startChildren(with deepLink: DeepLink) {
        childCoordinators.forEach { $1.start(with: deepLink) }
    }

}

// MARK: - Coordinator
class Coordinator: BaseCoordinator {
    let router: RouterType

    init(router: RouterType) {
        self.router = router
    }
}

extension Coordinator: Presentable {
    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}
