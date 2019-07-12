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
    let launchStatus: LaunchStatus?
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
        self.launchStatus = deal.launchStatus
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

// MARK: - Lens

extension Deal {
    enum lens {
        static let features = Lens<Deal, String>(
            get: { $0.features },
            set: { part in
                { whole in
                    Deal.init(features: part, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let id = Lens<Deal, String>(
            get: { $0.id },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: part, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let items = Lens<Deal, [Item]>(
            get: { $0.items },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: part, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let photos = Lens<Deal, [URL]>(
            get: { $0.photos },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: part, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let purchaseQuantity = Lens<Deal, PurchaseQuantity?>(
            get: { $0.purchaseQuantity },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: part, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let title = Lens<Deal, String>(
            get: { $0.title },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: part, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let specifications = Lens<Deal, String>(
            get: { $0.specifications },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: part, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let story = Lens<Deal, Story>(
            get: { $0.story },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: part, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let theme = Lens<Deal, Theme>(
            get: { $0.theme },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: part, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let url = Lens<Deal, URL>(
            get: { $0.url },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: part, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let soldOutAt = Lens<Deal, Date?>(
            get: { $0.soldOutAt },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: part, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let launches = Lens<Deal, [Launch]?>(
            get: { $0.launches },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: part, launchStatus: whole.launchStatus, topic: whole.topic)
                }
        }
        )
        static let launchStatus = Lens<Deal, LaunchStatus?>(
            get: { $0.launchStatus },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: part, topic: whole.topic)
                }
        }
        )
        static let topic = Lens<Deal, Topic?>(
            get: { $0.topic },
            set: { part in
                { whole in
                    Deal.init(features: whole.features, id: whole.id, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, title: whole.title, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: part)
                }
        }
        )
    }
}
