//
//  Models+create.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/16/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation
import UIKit
@testable import Adequate

// MARK: - Additional

extension URL {
    static func create(
        string: String = ""
    ) -> URL {
        return URL(string: "https://www.apple.com")!
    }
}

// MARK: - Primary

extension MehResponse {
    static func create(
        deal: Deal = Deal.create(),
        poll: Poll? = nil,
        video: Video? = nil
    ) -> MehResponse {
        return MehResponse(deal: deal, poll: poll, video: video)
    }
}

extension Deal {

    static func create(
        features: String = "",
        id: String = "",
        items: [Item] = [],
        photos: [URL] = [],
        purchaseQuantity: PurchaseQuantity? = nil,
        title: String = "",
        specifications: String = "",
        story: Story = Story.create(),
        theme: Theme = Theme.create(),
        url: URL = URL.create(),
        soldOutAt: Date? = nil,
        launches: [Launch]? = nil,
        launchStatus: LaunchStatus = .launch,
        topic: Topic? = nil
    ) -> Deal {
        return Deal(features: features,
                    id: id,
                    items: items,
                    photos: photos,
                    purchaseQuantity: purchaseQuantity,
                    title: title,
                    specifications: specifications,
                    story: story,
                    theme: theme,
                    url: url,
                    soldOutAt: soldOutAt,
                    launches: launches,
                    launchStatus: launchStatus,
                    topic: topic)
    }
}

extension Item.ItemAttribute {
    static func create(
        key: String = "",
        value: String = ""
    ) -> Item.ItemAttribute {
        return Item.ItemAttribute(key: key, value: value)
    }
}

extension Item {
    static func create(
        attributes: [Item.ItemAttribute] = [],
        condition: String = "",
        id: String = "",
        price: Double = 0.0,
        photo: URL = URL.create()
    ) -> Item {
        return Item(attributes: attributes, condition: condition, id: id, price: price, photo: photo)
    }
}

extension Poll.Answer {
    static func create(
        id: String = "",
        text: String = "",
        voteCount: Int = 0
    ) -> Poll.Answer {
        return Poll.Answer(id: id, text: text, voteCount: voteCount)
    }
}

extension Poll {
    static func create(
        answers: [Answer] = [],
        id: String = "",
        startDate: Date = Date(),
        title: String = "",
        topic: Topic? = nil
    ) -> Poll {
        return Poll(answers: answers, id: id, startDate: startDate, title: title, topic: topic)
    }
}

extension PriceComparison {
    static func create(
        price: String = "",
        store: String = "",
        url: URL? = nil
    ) -> PriceComparison {
        return PriceComparison(price: price, store: store, url: url)
    }
}

extension Story {
    static func create(
        title: String = "",
        body: String = ""
    ) -> Story {
        return Story(title: title, body: body)
    }
}

extension Theme {
    static func create(
        accentColor: UIColor = .clear,
        backgroundColor: UIColor = .clear,
        foreground: ThemeForeground = .light
    ) -> Theme {
        return Theme(accentColor: accentColor, backgroundColor: backgroundColor, foreground: foreground)
    }
}

extension Topic {
    static func create(
        commentCount: Int = 0,
        createdAt: Date = Date(),
        id: String = "",
        replyCount: Int = 0,
        url: URL = URL.create(),
        voteCount: Int = 0
    ) -> Topic {
        return Topic(commentCount: commentCount, createdAt: createdAt, id: id, replyCount: replyCount, url: url, voteCount: voteCount)
    }
}

extension Video {
    static func create(
        id: String = "",
        startDate: Date = Date(),
        title: String = "",
        url: URL = URL.create(),
        topic: Topic? = nil
    ) -> Video {
        return Video(id: id, startDate: startDate, title: title, url: url, topic: topic)
    }
}
