//
//  SyncClientError.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync

public enum SyncClientError: Error {
    case network(error: Error) // Capture any underlying Error
    case authentication(error: Error)
    case graphQL(errors: [Error])
    case missingData(data: GraphQLSelectionSet) // TODO: rename `noData`
    case missingClient
    case myError(message: String)
    case unknown(error: Error)
}

extension SyncClientError {

    /// Returns an error wrapped in SyncClientError.
    static func wrap(_ error: Error) -> Self {
        if let appSyncError = error as? AWSAppSyncClientError {
            /*
            // TODO: handle different AWSAppSyncClientError
            // https://techlife.cookpad.com/entry/2019/06/14/160000
            // For `.requestFailed`, the Cocoa error can be extracted and `.localizedDescription` shown to the user.
            // Other cases probably aren't that useful. `AWSAppSyncClientError` conforms to `LocalizedError`,
            // but the error messages are English only and usually add various codes that would probably be unideal
            // to show users.
             */
            switch appSyncError {
            case .requestFailed(_, _, let underlyingError):
                // TODO: look at response / data
                log.error("\(#function) - AWSAppSyncClientError.appSyncError: \(underlyingError?.localizedDescription ?? "No Error") ")
            case .noData(let response):
                log.error("\(#function) - AWSAppSyncClientError.noData: \(response) ")
            case .parseError(_, _, let underlyingError):
                log.error("\(#function) - AWSAppSyncClientError.parseError: \(underlyingError?.localizedDescription ?? "No Error") ")
            case .authenticationError(let underlyingError):
                log.error("\(#function) - AWSAppSyncClientError.authenticationError: \(underlyingError.localizedDescription) ")
                return .authentication(error: underlyingError)
            }
            return .network(error: appSyncError)
        } else {
            // TODO: would this be unknown or just .network?
            return .unknown(error: error)
        }
    }
}

// MARK: - LocalizedError
extension SyncClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network Error: \(error.localizedDescription)"
        case .authentication(let error):
            return "Authentication Error: \(error.localizedDescription)"
        case .graphQL(let errors):
            return errors.map { $0.localizedDescription }.joined(separator: "\n")
        case .missingData(let data):
            return "Missing data for \(String(describing: data))"
        case .missingClient:
            return "Unable to initialize client"
        case .myError(let message):
            return message
        case .unknown(let error):
            return "Unknown Error: \(error.localizedDescription)"
        }
    }
}
