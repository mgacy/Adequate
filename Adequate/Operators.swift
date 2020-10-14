//
//  Operators.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

precedencegroup AssociativityLeft { associativity: left }


// MARK: - Function Composition

infix operator >>>: AssociativityLeft

/// Compose functions.
/// - Parameters:
///   - f: function (A) -> B
///   - g: function (B) -> C
/// - Returns: composed function (A) -> B
///
/// Example:
///
///    func square(_ x: Int) -> Int {
///        return x * x
///    }
///
///    func increment(_ x: Int) -> Int {
///        return x + 1
///    }
///
///    func describe(_ val: CustomStringConvertible) -> String {
///        return "The resulting value is: \(val)"
///    }
///
///    (square >>> increment >>> describe)(3)  // "The resulting value is: 10"
///
func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { x in g(f(x)) }
}


// Mark: - Lens Composition

infix operator .. : AssociativityLeft

/// Compose Lenses.
/// - Parameters:
///   - lhs: Lens<Whole,Part>
///   - rhs: Lens<Part,Subpart>
/// - Returns: composed Lens<Whole,Subpart>
///
/// Example:
///
///    struct Person {
///        let name : String
///        let address : Address
///
///        enum lens {
///            static let address = Lens<Person,Address>(
///                get: { $0.address },
///                set: { part in
///                    { whole in
///                        Person.init(name: whole.name, address: part)
///                    }
///                }
///            )
///        }
///    }
///
///    struct Address {
///        let street : String
///        let city : String
///
///        enum lens {
///            static let street = Lens<Address,String>(
///                get: { $0.street },
///                set: { part in
///                    { whole in
///                        Address.init(street: part, city: whole.city)
///                    }
///                }
///            )
///        }
///    }
///
///    let robb = Person(name: "Robb", address: Address(street: "Alexanderplatz", city: "Berlin"))
///
///    let composedLens = Person.lens.address..Address.lens.street
///
///    let robb2 = composedLens.set("Kottbusser Damm")(robb)
///    // Creates a new `Person` with an updated street
///
extension Lens {
    static func .. <Subpart> (lhs: Lens<Whole,Part>, rhs: Lens<Part,Subpart>) -> Lens<Whole,Subpart> {
        return lhs.then(rhs)
    }
}
