//
//  NetworkClientError.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

public enum NetworkClientError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case authentication(error: Error)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case objectSerialization(reason: String)
    case imageDecodingFailed
    //case malformedRequest
    case badRequest
    // AlamofireDecodableError: case invalidKeyPath
    // AlamofireDecodableError: case emptyKeyPath
    case myError(message: String)
}

/// TODO: add static method on mapping status

extension NetworkClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network Error: \(error.localizedDescription)"
        case .authentication(let error):
            return "Authentication Error: \(error.localizedDescription)"
        case .dataSerialization(let error):
            return "Data Serialization Error: \(error.localizedDescription)"
        case .jsonSerialization(let error):
            return "JSON Serialization Error: \(error.localizedDescription)"
        case .objectSerialization(let reason):
            return "Object Serialization Error: \(reason)"
        case .imageDecodingFailed:
            return "Unable to decode image"
        case .badRequest:
            return "Bad Request"
        case .myError(let message):
            return message
        }
    }
}
