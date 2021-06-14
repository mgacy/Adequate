//
//  ViewState+Prism.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/8/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import Foundation

// https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/
extension ViewState {
    // swiftlint:disable:next type_name
    enum prism {
        static var result: Prism<ViewState, Element> {
            return Prism<ViewState, Element>.init(
                tryGet: {
                    guard case .result(let element) = $0 else { return nil }
                    return element
                },
                inject: { .result($0) })
        }

        static var error: Prism<ViewState, Error> {
            return Prism<ViewState, Error>.init(
                tryGet: {
                    guard case .error(let error) = $0 else { return nil }
                    return error
                },
                inject: { .error($0) })
        }
    }
}
