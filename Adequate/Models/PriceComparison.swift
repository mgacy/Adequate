//
//  PriceComparison.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct PriceComparison: Equatable {
    let price: String // FIXME: shouldn't this really be a Double?
    //let quantity: Int? // FIXME: should this be optional, or should the default value simply be 1?
    //let description: String?
    let store: String
    let url: URL?

    // TODO: add failable init accepting `specifications: String`?

}
