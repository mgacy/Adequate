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
    static let onboarding = "onboarding"
}

enum DeepLink {
    case onboarding
    case buy(URL)
    case meh

    static func build(with userActivity: NSUserActivity) -> DeepLink? {
        return nil
    }

    static func build(with dict: [String: AnyObject]?) -> DeepLink? {
        guard let id = dict?["launch_id"] as? String else { return nil }

        switch id {
        case DeepLinkURLConstants.onboarding: return .onboarding
        default: return nil
        }
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

class BaseCoordinator: CoordinatorType {

    /// Unique identifier.
    internal let identifier = UUID()

    private var childCoordinators = [UUID: Any]()

    func store(coordinator: CoordinatorType) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    func free(coordinator: CoordinatorType) {
        childCoordinators[coordinator.identifier] = nil
    }

    // MARK: A

    public func start() {
        start(with: nil)
    }

    public func start(with deepLink: DeepLink?) {
        // ...
    }

    public func coordinate(to coordinator: CoordinatorType) {
        store(coordinator: coordinator)
        coordinator.start()
    }

    public func coordinate(to coordinator: CoordinatorType, with deepLink: DeepLink? = nil) {
        /// TODO: set onFinishFlow on coordinator
        store(coordinator: coordinator)
        coordinator.start(with: deepLink)
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

}
