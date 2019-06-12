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

// MARK: - GetDealQuery.Data.GetDeal
extension Deal {
    init?(_ deal: GetDealQuery.Data.GetDeal) {
        guard
            let url = URL(string: deal.url),
            let story = Story(deal.story)
            else {
                return nil
        }

        self.features = deal.features
        self.id = deal.id
        self.items = deal.items.compactMap { Item($0) }
        self.photos = deal.photos.compactMap { URL(string: $0) }
        self.purchaseQuantity = PurchaseQuantity(deal.purchaseQuantity)
        self.title = deal.title
        self.specifications = deal.specifications
        self.story = story
        self.theme = Theme(deal.theme)
        self.url = url
        if let soldOutAt = deal.soldOutAt {
            self.soldOutAt = DateFormatter.iso8601Full.date(from: soldOutAt)
        } else {
            self.soldOutAt = nil
        }
        self.launches = deal.launches?.compactMap { Launch($0) }
        self.topic = Topic(deal.topic)
    }

    init?(_ deal: GetDealQuery.Data.GetDeal?) {
        guard let deal = deal else { return nil }
        self.init(deal)
    }
}

// MARK: - Initializers

extension Deal.Launch {
    init(_ launch: GetDealQuery.Data.GetDeal.Launch) {
        soldOutAt = launch.soldOutAt
    }

    init?(_ launch: GetDealQuery.Data.GetDeal.Launch?) {
        guard let launch = launch else { return nil }
        self.init(launch)
    }
}

extension Deal.Launch {
    init(_ launch: LaunchType) {
        soldOutAt = launch.soldOutAt
    }

    init?(_ launch: LaunchType?) {
        guard let launch = launch else { return nil }
        self.init(launch)
    }
}

extension Deal.PurchaseQuantity {
    init(_ purchaseQuantity: PurchaseQuantityType) {
        self.minimumLimit = purchaseQuantity.minimumLimit
        self.maximumLimit = purchaseQuantity.maximumLimit
    }

    init?(_ purchaseQuantity: PurchaseQuantityType?) {
        guard let purchaseQuantity = purchaseQuantity else { return nil }
        self.init(purchaseQuantity)
    }
}
