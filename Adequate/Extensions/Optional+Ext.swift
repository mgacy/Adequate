//
//  Optional+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/9/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

public struct NilError: Error { }

public extension Optional {

    // https://github.com/khanlou/Promise
    func unwrap() throws -> Wrapped {
        guard let result = self else {
            throw NilError()
        }
        return result
    }
}
