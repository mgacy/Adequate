//
//  URL+Ext.swift
//  
//
//  Created by Mathew Gacy on 6/8/21.
//

import Foundation

// Via John Sundell: https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        guard let url = URL(string: "\(value)") else {
            preconditionFailure("Invalid static URL string: \(value)")
        }
        self = url
    }
}
