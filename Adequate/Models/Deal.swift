//
//  Deal.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

// sourcery: lens
public struct Deal: Codable {

    public struct PurchaseQuantity: Codable, Equatable {
        public let maximumLimit: Int
        public let minimumLimit: Int
    }

    public struct Launch: Codable, Equatable {
        public let soldOutAt: String?
    }

    public let id: String
    public let dealID: String
    public let title: String
    public let features: String
    public let items: [Item]
    public let photos: [URL]
    public let purchaseQuantity: PurchaseQuantity?
    public let specifications: String
    public let story: Story
    public let theme: Theme
    public let url: URL
    public let createdAt: Date
    //public let updatedAt: Date
    //public let lastChangedAt:
    //public let endDate: Date?
    public let soldOutAt: Date?
    public let launches: [Launch]?
    public let launchStatus: LaunchStatus?
    public let topic: Topic?
}

// MARK: - Equatable
extension Deal: Equatable {
    /*
    // TODO: is there really a an appreciable advantage to limiting check to only these properties?
    static func == (lhs: Deal, rhs: Deal) -> Bool {
        return lhs.id == rhs.id
            && lhs.dealID == rhs.dealID
            && lhs.soldOutAt == rhs.soldOutAt
            && lhs.launches == rhs.launches
            && lhs.launchStatus == rhs.launchStatus
            && lhs.topic == rhs.topic
    }
    */
}

// MARK: - CustomStringConvertible
extension Deal: CustomStringConvertible {

    public var description: String {
        let status = launchStatus != nil ? ".\(launchStatus!.rawValue)" : "nil"
        if let topic = topic {
            // swiftlint:disable:next line_length
            return "Deal(id: \"\(id)\", dealID: \"\(dealID)\", title: \"\(title)\", launchStatus: \(status)), topic: Topic(commentCount: \(topic.commentCount), createdAt: \(topic.createdAt), id: \(topic.id))"
        }
        return "Deal(id: \"\(id)\", dealID: \"\(dealID)\", title: \"\(title)\", launchStatus: \(status))"
    }
}

// MARK: - Initializers

// MARK: GetDealQuery.Data.GetDeal
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
        self.dealID = deal.dealId
        self.items = deal.items.compactMap { Item($0) }
        self.photos = deal.photos.compactMap { URL(string: $0) }
        self.purchaseQuantity = PurchaseQuantity(deal.purchaseQuantity)
        self.title = deal.title
        self.specifications = deal.specifications
        self.story = story
        self.theme = Theme(deal.theme)
        self.url = url
        self.createdAt = DateFormatter.iso8601Full.date(from: deal.createdAt) ?? .distantPast
        if let soldOutAt = deal.soldOutAt {
            self.soldOutAt = DateFormatter.iso8601Full.date(from: soldOutAt)
        } else {
            self.soldOutAt = nil
        }
        self.launches = deal.launches?.compactMap { Launch($0) }
        self.launchStatus = deal.launchStatus
        self.topic = Topic(deal.topic)
    }

    init?(_ deal: GetDealQuery.Data.GetDeal?) {
        guard let deal = deal else { return nil }
        self.init(deal)
    }
}

extension Deal.Launch {

    init(_ launch: GetDealQuery.Data.GetDeal.Launch) {
        soldOutAt = launch.soldOutAt
    }

    init?(_ launch: GetDealQuery.Data.GetDeal.Launch?) {
        guard let launch = launch else { return nil }
        self.init(launch)
    }
}

// MARK: Model Protocols
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
