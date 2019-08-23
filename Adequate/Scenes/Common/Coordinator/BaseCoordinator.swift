//
//  BaseCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
//import UserNotifications

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
