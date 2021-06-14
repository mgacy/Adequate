//
//  HeaderField.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

/// Additional information about the resource to be fetched or the client requesting the resource.
public enum HeaderField: Equatable, HeaderFieldProtocol {

    public enum ContentType: RawRepresentable, Equatable {
        /// "application/json".
        case json
        /// "application/xml".
        case xml
        /// "application/x-www-form-urlencoded".
        case urlencoded
        /// "image/webp".
        case webp
        /// "image/apng".
        case png
        /// "text/html".
        case text
        /// Custom value.
        case custom(String)

        public init?(rawValue: String) {
            switch rawValue {
            case Raw.json.rawValue:
                self = .json
            case Raw.xml.rawValue:
                self = .xml
            case Raw.urlencoded.rawValue:
                self = .urlencoded
            case Raw.webp.rawValue:
                self = .webp
            case Raw.png.rawValue:
                self = .png
            case Raw.text.rawValue:
                self = .text
            default:
                self = .custom(rawValue)
            }
        }

        public var rawValue: String {
            switch self {
            case .json:
                return Raw.json.rawValue
            case .xml:
                return Raw.xml.rawValue
            case .urlencoded:
                return Raw.urlencoded.rawValue
            case .webp:
                return Raw.webp.rawValue
            case .png:
                return Raw.png.rawValue
            case .text:
                return Raw.text.rawValue
            case .custom(let rawValue):
                return rawValue
            }
        }

        // swiftlint:disable:next nesting type_name
        enum Raw: String, Equatable {
            case json = "application/json"
            case xml = "application/xml"
            case urlencoded = "application/x-www-form-urlencoded"
            case webp = "image/webp"
            case png = "image/apng"
            case text = "text/html"
        }
    }

    case accept(ContentType) // [ContentType]?
    case apiKey(String)
    case cacheControl(String)
    case contentTransferEncoding(String)
    case contentType(ContentType)
    case ifMatch(String)
    case ifNoneMatch(String)
    case custom(name: String, value: String?)

    /// Header field name.
    public var name: String {
        switch self {
        case .accept: return "Accept"
        case .apiKey: return "X-API-Key"
        case .cacheControl: return "Cache-Control"
        case .contentTransferEncoding: return "Content-Transfer-Encoding"
        case .contentType: return "Content-Type"
        case .ifMatch: return "If-Match"
        case .ifNoneMatch: return "If-None-Match"
        case .custom(name: let fieldName, _): return fieldName
        }
    }

    /// Header field value.
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
        [
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
