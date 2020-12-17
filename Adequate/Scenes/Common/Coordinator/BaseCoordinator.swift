//
//  BaseCoordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class BaseCoordinator: NSObject, CoordinatorType {

    /// Unique identifier.
    internal let identifier = UUID()

    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    private var childCoordinators = [UUID: CoordinatorType]()

    /// Stores the coordinator to the `childCoordinators` dictionary.
    /// - Parameter coordinator: Child coordinator to store.
    func store(coordinator: CoordinatorType) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// Releases the coordinator from the `childCoordinators` dictionary.
    /// - Parameter coordinator: Child coordinator to release.
    func free(coordinator: CoordinatorType) {
        // TODO: accept optional to avoid weak/strong dance in onFinishFlow
        // TODO: recursively free children coordinators?
        childCoordinators[coordinator.identifier] = nil
    }

    // MARK: A

    /// Starts the job of the coordinator.
    public func start() {
        start(with: nil)
    }

    /// Starts the job of the coordinator or any children handling `deepLink`.
    /// - Parameter deepLink: DeepLink.
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

extension BaseCoordinator {

    func coordinate<T: FinishableCoordinatorType>(
        to coordinator: T,
        with deepLink: DeepLink? = nil,
        onFinish: ((T.CoordinationResult) -> Void)? = nil)
    {
        store(coordinator: coordinator)
        coordinator.onFinishFlow = onFinish
        coordinator.start(with: deepLink)
    }
}
