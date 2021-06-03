//
//  URLRequest+Ext.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

// MARK: - HeaderProtocol
public extension URLRequest {

    mutating func setHeader(_ header: HeaderProtocol) {
        setValue(header.value, forHTTPHeaderField: header.field)
    }

    mutating func setHeaders(_ headers: [HeaderProtocol]) {
        allHTTPHeaderFields = headers.reduce(into: [:]) { dict, header in
            dict[header.field] = header.value
        }
    }
}

// MARK: - URLRequestConvertible
extension URLRequest: URLRequestConvertible {
    public func asURLRequest() -> URLRequest {
        return self
    }
}
