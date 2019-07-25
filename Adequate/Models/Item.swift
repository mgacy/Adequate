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
    let price: Double
    let photo: URL
}

// MARK: - Initializers

extension Item {
    init?(_ item: ItemType) {
        guard let photo = URL(string: item.photo) else { return nil }
        self.attributes = [] // FIXME: implement
        self.condition = item.condition
        self.id = item.id
        self.price = item.price
        self.photo = photo
    }
}

extension Item {
    init?(_ item: GetDealQuery.Data.GetDeal.Item) {
        guard let photo = URL(string: item.photo) else { return nil }
        self.attributes = [] // FIXME: implement
        self.condition = item.condition
        self.id = item.id
        self.price = item.price
        self.photo = photo
    }
}
