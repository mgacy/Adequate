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
    case graphQL(errors: [Error])
    case missingData(data: GraphQLSelectionSet)
    case missingClient
    case myError(message: String)
}

// MARK: - LocalizedError
extension SyncClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network Error: \(error.localizedDescription)"
        case .graphQL(let errors):
            return errors.map { $0.localizedDescription }.joined(separator: "\n")
        case .missingData(let data):
            return "Missing data for \(String(describing: data))"
        case .missingClient:
            return "Unable to initialize client"
        case .myError(let message):
            return message
        }
    }
}
