//
//  PriceComparison.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct PriceComparison: Equatable {
    // String since extract this from `Deal.specifications` and immediately display. It remains US currency, so no
    // need to reformat
    let price: String
    //let quantity: Int
    //let description: String?
    let store: String
    let url: URL?
}
