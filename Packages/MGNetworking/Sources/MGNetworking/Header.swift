//
//  Header.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

public enum Header: Equatable, HeaderProtocol {

    public enum ContentType: String, Equatable {
        case json = "application/json"
        case xml = "application/xml"
        case urlencoded = "application/x-www-form-urlencoded"
    }

    case accept(ContentType)
    case apiKey(String)
    case cacheControl(String)
    case contentTransferEncoding(String)
    case contentType(ContentType)
    case ifMatch(String)
    case ifNoneMatch(String)
    case custom(fieldName: String, value: String?)

    public var field: String {
        switch self {
        case .accept: return "Accept"
        case .apiKey: return "X-API-Key"
        case .cacheControl: return "Cache-Control"
        case .contentTransferEncoding: return "Content-Transfer-Encoding"
        case .contentType: return "Content-Type"
        case .ifMatch: return "If-Match"
        case .ifNoneMatch: return "If-None-Match"
        case .custom(fieldName: let fieldName, _): return fieldName
        }
    }

    public var value: String? {
        switch self {
        case .accept(let contentType): return contentType.rawValue
        case .apiKey(let key): return key
        case .cacheControl(let value): return value
        case .contentTransferEncoding(let value): return value
        case .contentType(let contentType): return contentType.rawValue
        case .ifMatch(let value): return value
        case .ifNoneMatch(let value): return value
        case .custom(_, value: let value): return value
        }
    }

    // TODO: check against these when using `.custom`
    /// HTTP headers reserved by the URL Loading System.
    /// See: https://developer.apple.com/documentation/foundation/nsurlrequest
    static var reservedHeaderFields: [String] {
        return [
            "Authorization",
            "Connection",
            "Content-Length",
            "Host",
            "Proxy-Authenticate",
            "Proxy-Authorization",
            "WWW-Authenticate"
        ]
    }

    // TODO: handle capitalization when testing equality of `.custom` (`"accept"` and `"Accept"`) s
    // See: https://forums.swift.org/t/dictionary-keys-equatable-conformance-is-unreliable/40140/8
}
