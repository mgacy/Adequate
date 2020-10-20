//
//  Optional+Prism.swift
//  Adequate
//
//  https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/
//

import Foundation

extension Optional {
    public static var prism: Prism<Optional,Wrapped> {
        return Prism<Optional,Wrapped>.init(
            tryGet: { $0 },
            inject: Optional.some)
    }
}
