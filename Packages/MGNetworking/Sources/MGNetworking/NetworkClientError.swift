//
//  NetworkClientError.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

public enum NetworkClientError: Error {
    //case invalidURL
    case malformedRequest
    /// Capture any underlying Error from the URLSession API
    case network(error: Error)
    /// No data returned from server.
    case noData
    /// The server response was in an unexpected format.
    case invalidResponse(URLResponse?)
    /// There was a client error: 400-499.
    case clientError(HTTPURLResponse)
    /// There was a server error.
    case serverError(HTTPURLResponse) // Add data also?
    /// There was an error decoding the data.
    case decoding(error: Error)
    /// Unknown error.
    case unknown(message: String)

    public static func wrap(_ error: Error) -> NetworkClientError {
        // swiftlint:disable force_cast
        switch error {
        case is NetworkClientError:
            return error as! NetworkClientError
        case is DecodingError:
            return .decoding(error: error)
        case is URLError:
            return .network(error: error)
        default:
            return .unknown(message: error.localizedDescription)
        }
        // swiftlint:enable force_cast
    }
}

// TODO: add static method on mapping status
extension NetworkClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .malformedRequest:
            return L10n.Error.malformedRequest
        case .network(let error):
            return L10n.Error.network(error.localizedDescription)
        case .noData:
            return L10n.Error.noData
        case .invalidResponse(let response):
            return L10n.Error.invalidResponse(String(describing: response))
        case .clientError(let response):
            return L10n.Error.clientError(response.statusCode)
        case .serverError(let response):
            return L10n.Error.serverError(response.statusCode)
        case .decoding(let error):
            return L10n.Error.decoding(error.localizedDescription)
        case .unknown(let message):
            return message
        }
    }
}
