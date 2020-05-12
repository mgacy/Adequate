//
//  Caching.swift
//  Adequate
//
//  Created by Mathew Gacy on 5/12/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
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
