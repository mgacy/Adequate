//
//  ViewState.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

//import Foundation

enum ViewState<Element> {
    case loading
    case result(Element)
    case empty
    case error(Error)
}

extension ViewState {
    func map<T>(_ transform: (Element) -> T) -> ViewState<T> {
        switch self {
        case .empty:
            return .empty
        case .loading:
            return .loading
        case .result(let result):
            return .result(transform(result))
        case .error(let error):
            return .error(error)
        }
    }
}

extension ViewState: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return "Empty"
        case .loading:
            return "Loading"
        case .result(let element):
            return "Result: \(element)"
        case .error(let error):
            return "Error: \(error.localizedDescription)"
        }
    }
}

extension ViewState: Equatable where Element: Equatable {
    static func == (lhs: ViewState<Element>, rhs: ViewState<Element>) -> Bool {
        switch(lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.result(let a), .result(let b)):
            return a == b
        case (.empty , .empty):
            return true
        // See the following on adding Equatable conformance to Error:
        // https://kandelvijaya.com/2018/04/21/blog_equalityonerror/
        // case(.error(let a), .error(let b)):
        default:
            return false
        }
    }
}

protocol ViewStateRenderable: class {
    associatedtype ResultType
    func render(_: ViewState<ResultType>)
}
