//
//  StatusCodeValidating.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

public protocol StatusCodeValidating {
    var statusCode: Int { get }
    func validateStatus() throws
}
