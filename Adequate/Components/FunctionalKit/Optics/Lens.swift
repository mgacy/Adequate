//
//  Lens.swift
//  Adequate
//
//  https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/
//

import Foundation

public struct Lens<Whole,Part> {
    public let get: (Whole) -> Part
    public let set: (Part) -> (Whole) -> Whole
}

public extension Lens {
    func then<Subpart>(_ other: Lens<Part,Subpart>) -> Lens<Whole,Subpart> {
        return Lens<Whole,Subpart>(
            get: { other.get(self.get($0)) },
            set: { (subpart: Subpart) in
                { (whole: Whole) -> Whole in
                    self.set(other.set(subpart)(self.get(whole)))(whole)
                }
            })
    }

    func modify(_ transform: @escaping (Part) -> Part) -> (Whole) -> Whole {
        return { whole in self.set(transform(self.get(whole)))(whole) }
    }

    func toAffine() -> Affine<Whole,Part> {
        return Affine<Whole,Part>.init(
            tryGet: self.get,
            trySet: self.set)
    }
}
