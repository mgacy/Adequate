//
//  CoordinatorType.swift
//  Adequate
//
//  https://github.com/imaccallum/CoordinatorKit
//

import Foundation

protocol CoordinatorType: AnyObject {

    /// Unique identifier.
    var identifier: UUID { get }

    /// Starts the job of the coordinator.
    func start()

    /// Starts the job of the coordinator or any children handling `deepLink`.
    /// - Parameter deepLink: DeepLink.
    func start(with: DeepLink?)
}
