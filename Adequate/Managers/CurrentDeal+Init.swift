//
//  CurrentDeal+Init.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import CurrentDealManager

extension CurrentDeal {
    init?(deal: Deal) {
        guard let imageURL = deal.photos.first?.secure() else {
            return nil
        }

        // Prices
        let minQuantity = Double(deal.purchaseQuantity?.minimumLimit ?? 1)
        let prices = deal.items.map { $0.price * minQuantity }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return nil
        }

        let launchStatus: CurrentDeal.LaunchStatus?
        if let statusString = deal.launchStatus?.rawValue {
            launchStatus = LaunchStatus(rawValue: statusString)
        } else {
            launchStatus = nil
        }

        self.init(id: deal.dealID,
                  title: deal.title,
                  imageURL: imageURL,
                  minPrice: minPrice,
                  maxPrice: minPrice != maxPrice ? maxPrice : nil,
                  launchStatus: launchStatus)
    }
}
