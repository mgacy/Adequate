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

// TODO: add static method on mapping status

extension NetworkClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return L10n.networkError(error.localizedDescription)
        case .authentication(let error):
            return L10n.authenticationError(error.localizedDescription)
        case .dataSerialization(let error):
            return L10n.dataSerializationError(error.localizedDescription)
        case .jsonSerialization(let error):
            return L10n.jsonSerializationError(error.localizedDescription)
        case .objectSerialization(let reason):
            return L10n.objectSerializationError(reason)
        case .imageDecodingFailed:
            return L10n.imageDecodingFailed
        case .badRequest:
            return L10n.badRequest
        case .myError(let message):
            return message
        }
    }
}
