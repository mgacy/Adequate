//
//  HeaderFieldProtocol.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

public protocol HeaderFieldProtocol {

    /// Header field name.
    var name: String { get }

    /// Header field value.
    var value: String? { get }
}
