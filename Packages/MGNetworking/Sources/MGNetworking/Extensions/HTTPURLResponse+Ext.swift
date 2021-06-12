//
//  HTTPURLResponse+Ext.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

// MARK: - HTTPURLResponse+StatusCodeValidating
extension HTTPURLResponse: StatusCodeValidating {
    public func validateStatus() throws {
        switch statusCode {
        // Informational
        //case (100..<200): return
        // Success
        case (200..<300): return
        // Redirection
        //case (300..<400): return
        // Client Error
        case (400..<500): throw NetworkClientError.clientError(self)
        // Server Error
        case (500..<600): throw NetworkClientError.serverError(self)
        default: throw NetworkClientError.unknown(message: "Unrecognized status code: \(statusCode)")
        }
    }
}
