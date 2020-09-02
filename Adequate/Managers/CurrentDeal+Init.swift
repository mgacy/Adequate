//
//  CurrentDeal+Init.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

extension CurrentDeal {
    init?(deal: Deal) {
        self.id = deal.dealID
        self.title = deal.title

        guard let imageURL = deal.photos.first?.secure() else {
            return nil
        }
        self.imageURL = imageURL

        // Prices
        let prices = deal.items.map { $0.price }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return nil
        }
        self.minPrice = minPrice
        self.maxPrice = minPrice != maxPrice ? maxPrice : nil
    }
}
