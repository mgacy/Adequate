//
//  Prism.swift
//  Adequate
//
//  https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/
//

import Foundation

struct Prism<Whole,Part> {
    let tryGet: (Whole) -> Part?
    let inject: (Part) -> Whole
}

extension Prism {
    func then<Subpart>(_ other: Prism<Part,Subpart>) -> Prism<Whole,Subpart> {
        return Prism<Whole,Subpart>(
            tryGet: { self.tryGet($0).flatMap(other.tryGet) },
            inject: { self.inject(other.inject($0)) })
    }

    func tryModify(_ transform: @escaping (Part) -> Part) -> (Whole) -> Whole {
        return { whole in self.tryGet(whole).map { self.inject(transform($0)) } ?? whole }
    }

    func toAffine() -> Affine<Whole,Part> {
        return Affine<Whole,Part>.init(
            tryGet: self.tryGet,
            trySet: { part in self.tryModify { _ in part } })
    }
}
