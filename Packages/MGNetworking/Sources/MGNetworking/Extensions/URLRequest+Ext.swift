//
//  URLRequest+Ext.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

// MARK: - HeaderFieldProtocol
public extension URLRequest {

    mutating func setHeader(_ field: HeaderFieldProtocol) {
        setValue(field.value, forHTTPHeaderField: field.name)
    }

    mutating func setHeaders(_ fields: [HeaderFieldProtocol]) {
        allHTTPHeaderFields = fields.reduce(into: [:]) { dict, field in
            dict[field.name] = field.value
        }
    }
}

// MARK: - URLRequestConvertible
extension URLRequest: URLRequestConvertible {
    public func asURLRequest() -> URLRequest {
        return self
    }
}
