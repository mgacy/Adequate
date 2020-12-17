//
//  PrimaryViewControllerType.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

// Should `PrimaryViewControllerType` conform to `RotationManaging` so we can avoid `SplitViewController.rotationManager`?
protocol PrimaryViewControllerType {

    // TODO: should `Configuration` and `Layout` sections be separate protocols?

    // MARK: - Configuration

    // This is how we will handle the `StateView`. Should we pass anything to it?
    func makeBackgroundView() -> UIView? // TODO: should this be a property?

    //func makeSecondaryView() -> UIView?

    // use `secondaryColumnGuide` to be more explicit?
    func configureConstraints(with secondaryColumnGuide: UILayoutGuide, in parentView: UIView) -> [NSLayoutConstraint]

    // MARK: - Layout

    // Based on `UIViewController.collapseSecondaryViewController(_:for:)`, `.separateSecondaryViewController(for:)`.
    // TODO: is there any need to also pass the `SplitViewController` as in those methods?

    /// Called when a `SplitViewController` transitions to a compact-width size class.
    /// - Parameter secondaryView: The secondary view associated with the split view controller.
    func collapseSecondaryView(_ secondaryView: UIView)

    /// Called when a `SplitViewController` transitions to a regular-width size class.
    func separateSecondaryView() -> UIView?
}

/// The methods adopted by an object used to perform additional work for a `SplitViewController` during rotation.
/// These methods are called by `UIViewController.viewWillTransition(to:with:)`.
protocol RotationManaging {

    /// Perform additional preparation before animating changes.
    func beforeRotation()

    // TODO: pass `size` as well?
    /// Perform additional animations alongside the transition animation..
    /// - Parameter : The contextual information for performing the animations provided by the transition coordinator
    ///               object managing the size change.
    func alongsideRotation(_: UIViewControllerTransitionCoordinatorContext)

    /// Perform additional work after the transition animation finishes.
    /// - Parameter : The contextual information for performing the animations provided by the transition coordinator
    ///               object managing the size change.
    func completeRotation(_: UIViewControllerTransitionCoordinatorContext)
}

// MARK: - Default Implementations
extension RotationManaging {

    func beforeRotation() {}

    func alongsideRotation(_: UIViewControllerTransitionCoordinatorContext) {}

    func completeRotation(_: UIViewControllerTransitionCoordinatorContext) {}
}
