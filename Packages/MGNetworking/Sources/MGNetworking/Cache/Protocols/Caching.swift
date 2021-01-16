//
//  Caching.swift
//  
//
//  Created by Mathew Gacy on 12/27/20.
//

import Foundation

public protocol Caching {
    associatedtype Key
    associatedtype Value

    func insert(_: Value, for: Key)
    func value(for: Key) -> Value?
    func removeValue(for: Key)
    func removeAll()
}
