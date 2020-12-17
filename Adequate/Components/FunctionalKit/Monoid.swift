//
//  Monoid.swift
//
//  https://itnext.io/semigroups-faf7a70da96a
//  https://gist.github.com/cjnevin/f683619e2841e71543c5e8fa0405c969
//

import Foundation

public protocol Monoid: Semigroup {
    static var empty: Self { get }
}

public func concat<M: Monoid>(_ values: [M]) -> M {
    return values.reduce(M.empty, <>)
}

// MARK: - Conformance for Standard Types

extension Numeric where Self: Monoid {
    public static var empty: Self { return 0 }
}

extension Int: Monoid { }

extension Bool: Monoid {
    public static let empty = true
}

extension String: Monoid {
    public static let empty = ""
}

extension Array: Monoid {
    public static var empty: Array {
        return []
    }
}

extension Sequence where Element: Monoid {
    public func joined() -> Element {
        return concat(Array(self))
    }
}
