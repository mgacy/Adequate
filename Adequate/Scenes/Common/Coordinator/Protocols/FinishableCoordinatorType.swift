//
//  FinishableCoordinatorType.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/4/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

protocol FinishableCoordinatorType: CoordinatorType {
    associatedtype CoordinationResult

    /// Closure to execute when finishing the coordinator's job.
    var onFinishFlow: ((CoordinationResult) -> Void)? { get set }

    /// Finishes the job of the coordinator.
    /// - Parameter with: Result of the coordinator's job.
    func finish(with: CoordinationResult)
}

// MARK: - Default Implementations
extension FinishableCoordinatorType {
    func finish(with result: CoordinationResult) {
        onFinishFlow?(result)
    }
}

// MARK: - VoidDismissalDelegate

// It would be nice to split `finish(with:)` into a separate protocol for view controllers to call, but the associated
// type requirement prevents us from using a protocol as the type of a view controller's `delegate` property. We can
// handle the simple case where a `FinishableCoordinatorType`'s `CoordinationResult` is `Void`.
protocol VoidDismissalDelegate: AnyObject {
    func dismiss()
}

// MARK: - Implementation for `DismissalDelegate` conformance.
// We can't declare conditional conformance to `VoidDismissalDelegate`, but we can at least provide an implementation
// so conforming types can simply declare conformance to `VoidDismissalDelegate`.
extension FinishableCoordinatorType where CoordinationResult == Void {
    func dismiss() {
        finish(with: ())
    }
}
