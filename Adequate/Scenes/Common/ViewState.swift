//
//  ViewState.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

public enum ViewState<Element> {
    case loading
    case result(Element)
    case empty
    case error(Error)
}

// MARK: - Operators
public extension ViewState {

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

// MARK: - CustomStringConvertible
extension ViewState: CustomStringConvertible {

    public var description: String {
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

// MARK: - Equatable
extension ViewState: Equatable where Element: Equatable {

    public static func == (lhs: ViewState<Element>, rhs: ViewState<Element>) -> Bool {
        switch(lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.result(let lhsElement), .result(let rhsElement)):
            return lhsElement == rhsElement
        case (.empty, .empty):
            return true
        // See the following on adding Equatable conformance to Error:
        // https://kandelvijaya.com/2018/04/21/blog_equalityonerror/
        // case(.error(let lhsError), .error(let rhsError)):
        default:
            return false
        }
    }
}

// MARK: - ViewStateRenderable
public protocol ViewStateRenderable: AnyObject {
    associatedtype ResultType
    func render(_: ViewState<ResultType>)
}
