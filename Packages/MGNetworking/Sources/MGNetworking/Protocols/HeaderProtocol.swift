//
//  HeaderProtocol.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation

public protocol HeaderProtocol {
    var field: String { get }
    var value: String? { get }
}
