//
//  CoordinatorType.swift
//  Adequate
//
//  https://github.com/imaccallum/CoordinatorKit
//

import Foundation

protocol CoordinatorType: AnyObject {
    //associatedtype CoordinationResult
    //associatedtype Transition
    //associatedtype Scene
    var identifier: UUID { get }
    func start()
    func start(with: DeepLink?)
}
