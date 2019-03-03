//
//  Item.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct Item: Codable, Equatable {

    struct ItemAttribute: Codable, Equatable {
        let key: String
        let value: String
    }

    let attributes: [ItemAttribute]
    let condition: String
    let id: String
    let price: Int
    let photo: URL
}
