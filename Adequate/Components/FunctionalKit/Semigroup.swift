//
//  Semigroup.swift
//
//  https://itnext.io/semigroups-faf7a70da96a
//  https://gist.github.com/cjnevin/9e9ef3f4f9a2f223c723ace9b0a959bf
//

import Foundation

public protocol Semigroup {
    func combine(with other: Self) -> Self
    static func <> (lhs: Self, rhs: Self) -> Self
}

extension Semigroup {
    public static func <> (lhs: Self, rhs: Self) -> Self {
        return lhs.combine(with: rhs)
    }
}

// Concatenate any type of Semigroup
//
// Example (1):
//
//     let a = true
//     let b = true
//     let c = false
//     concat([a, b, c], initial: true) // false
//
// Example (2):
//
//     let spicy = ["Pepper", "Chilli"]
//     let sweet = ["Mango", "Pineapple"]
//     let sour = ["Lemon", "Sauerkraut"]
//     let dish = concat([spicy, sweet, sour], initial: [])
//     // ["Pepper", "Chilli", "Mango", "Pineapple", "Lemon", "Sauerkraut"]
//
public func concat<S: Semigroup>(_ values: [S], initial: S) -> S {
    return values.reduce(initial, <>)
}

// MARK: - Conformance for Standard Types

extension Numeric where Self: Semigroup {
    public func combine(with other: Self) -> Self {
        return self + other
    }
}

extension Int: Semigroup { }

extension Array: Semigroup {
    public func combine(with other: Array) -> Array {
        return self + other
    }
}

extension String: Semigroup {
    public func combine(with other: String) -> String {
        return self + other
    }
}

extension Bool: Semigroup {
    public func combine(with other: Bool) -> Bool {
        return self && other
    }
}
