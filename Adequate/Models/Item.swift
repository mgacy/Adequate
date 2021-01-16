//
//  Item.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

public struct Item: Codable, Equatable {

    public struct ItemAttribute: Codable, Equatable {
        public let key: String
        public let value: String
    }

    //public let attributes: [ItemAttribute]
    public let condition: String
    public let id: String
    public let price: Double
    public let photo: URL
}

// MARK: - Initializers

public extension Item {

    init?(_ item: ItemType) {
        guard let photo = URL(string: item.photo) else { return nil }
        // self.attributes = []
        self.condition = item.condition
        self.id = item.id
        self.price = item.price
        self.photo = photo
    }
}

extension Item {

    init?(_ item: GetDealQuery.Data.GetDeal.Item) {
        guard let photo = URL(string: item.photo) else { return nil }
        // self.attributes = []
        self.condition = item.condition
        self.id = item.id
        self.price = item.price
        self.photo = photo
    }
}
