//
//  PriceComparison.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

public struct PriceComparison: Equatable {
    // String since extract this from `Deal.specifications` and immediately display. It remains US currency, so no
    // need to reformat
    public let price: String
    //public let quantity: Int
    //public let description: String?
    public let store: String
    public let url: URL?
}
