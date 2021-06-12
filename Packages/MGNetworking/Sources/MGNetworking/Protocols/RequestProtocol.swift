//
//  RequestProtocol.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

public protocol RequestProtocol: URLRequestConvertible {
    associatedtype Response
    var decode: (Data) throws -> Response { get }
}
