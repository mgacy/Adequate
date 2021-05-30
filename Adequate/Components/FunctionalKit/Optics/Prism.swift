//
//  Prism.swift
//  Adequate
//
//  https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/
//

import Foundation

public struct Prism<Whole, Part> {
    public let tryGet: (Whole) -> Part?
    public let inject: (Part) -> Whole
}

public extension Prism {
    func then<Subpart>(_ other: Prism<Part, Subpart>) -> Prism<Whole, Subpart> {
        return Prism<Whole, Subpart>(
            tryGet: { self.tryGet($0).flatMap(other.tryGet) },
            inject: { self.inject(other.inject($0)) })
    }

    func tryModify(_ transform: @escaping (Part) -> Part) -> (Whole) -> Whole {
        return { whole in self.tryGet(whole).map { self.inject(transform($0)) } ?? whole }
    }

    func toAffine() -> Affine<Whole, Part> {
        return Affine<Whole, Part>.init(
            tryGet: self.tryGet,
            trySet: { part in self.tryModify { _ in part } })
    }

    /// Check that an enum is a particular case.
    ///
    /// Usage:
    ///
    ///     let dealResult: ViewState<Deal> = .result(Deal())
    ///     let resultPrism = Prism<ViewState, Deal>(...)
    ///     resultPrism.isCase(dealResult) // true
    ///
    /// - Parameter whole: Instance of a `enum` on which a `Prism` is defined.
    /// - Returns: Boolean indicating whether `whole` is a case
    func isCase(_ whole: Whole) -> Bool {
        return tryGet(whole) != nil
    }
}
