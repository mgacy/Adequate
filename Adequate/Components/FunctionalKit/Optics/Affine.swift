//
//  Affine.swift
//  Adequate
//
//  https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/
//

import Foundation

public struct Affine<Whole,Part> {
    public let tryGet: (Whole) -> Part?
    public let trySet: (Part) -> (Whole) -> Whole?
}

public extension Affine {
    func then <Subpart> (_ other: Affine<Part,Subpart>) -> Affine<Whole,Subpart> {
        return Affine<Whole,Subpart>.init(
            tryGet: { s in self.tryGet(s).flatMap(other.tryGet) },
            trySet: { bp in
                { s in
                    self.tryGet(s)
                        .flatMap { a in other.trySet(bp)(a) }
                        .flatMap { b in self.trySet(b)(s) }
                }
        })
    }
}
