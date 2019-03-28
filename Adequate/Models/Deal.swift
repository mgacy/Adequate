//
//  Deal.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct Deal: Codable {

    struct PurchaseQuantity: Codable, Equatable {
        let maximumLimit: Int
        let minimumLimit: Int
    }

    struct Launch: Codable, Equatable {
        let soldOutAt: String?
    }

    let features: String
    let id: String
    let items: [Item]
    let photos: [URL]
    let purchaseQuantity: PurchaseQuantity?
    let title: String
    let specifications: String
    let story: Story
    let theme: Theme
    let url: URL
    let soldOutAt: Date?
    let launches: [Launch]?
    let topic: Topic?
}

// MARK: - Equatable
extension Deal: Equatable {
    static func == (lhs: Deal, rhs: Deal) -> Bool {
        return lhs.id == rhs.id && lhs.soldOutAt == rhs.soldOutAt && lhs.topic == rhs.topic
    }
}
