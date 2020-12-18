//
//  SyncClientError.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSAppSync

public enum SyncClientError: Error {
    /// Capture an underlying network error.
    case network(error: Error)
    /// Unable to initialize client.
    case missingClient
    /// Failed to authenticate request.
    case authentication(error: Error)
    /// Response contained GraphQL errors.
    case graphQL(errors: [GraphQLError])
    /// Result data was missing expected field.
    /// Raised if, for example, `GetDealQuery.Data.getDeal` were `nil` in absence of other errors.
    case missingField(selectionSet: GraphQLSelectionSet) // TODO: pass String of expected field?
    // TODO: isn't `missingField` really only about missing current Deal?
    /// Capture any other unexpected error.
    case unknown(error: Error)

    // The following errors should not happen, but I have been encountering `.emptyOperationHandler` at least

    /// `OperationResultHandler` returned neither result nor error.
    case emptyOperationHandler
    /// `GraphQLResult` contained neither data nor errors.
    case emptyResult // TODO: include `GraphQLResult.source`?
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
            // swiftlint:disable line_length
            switch appSyncError {
            case .requestFailed(_, _, let underlyingError):
                // "Did not receive a successful HTTP code."
                // TODO: look at response / data
                log.error("\(#function) - AWSAppSyncClientError.appSyncError: \(underlyingError?.localizedDescription ?? "No Error") ")
                if let _underlyingError = underlyingError {
                    return .network(error: _underlyingError)
                }
            case .noData(let response):
                // "No Data received in response."
                log.error("\(#function) - AWSAppSyncClientError.noData: \(response) ")
            case .parseError(_, _, let underlyingError):
                // "Could not parse response data."
                log.error("\(#function) - AWSAppSyncClientError.parseError: \(underlyingError?.localizedDescription ?? "No Error") ")
            case .authenticationError(let underlyingError):
                // "Failed to authenticate request."
                log.error("\(#function) - AWSAppSyncClientError.authenticationError: \(underlyingError.localizedDescription) ")
                return .authentication(error: underlyingError)
            }
            // swiftlint:enable line_length
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
            return L10n.networkError(error.localizedDescription)
        case .missingClient:
            return L10n.missingClient
        case .authentication(let error):
            return L10n.authenticationError(error.localizedDescription)
        case .graphQL(let errors):
            return errors.map { $0.localizedDescription }.joined(separator: "\n")
        case .missingField(let data):
            return L10n.missingField(String(describing: data))
        case .unknown(let error):
            return L10n.unknownError(error.localizedDescription)
        case .emptyOperationHandler:
            return L10n.emptyOperationHandler
        case .emptyResult:
            return L10n.emptyResult
        }
    }
}
