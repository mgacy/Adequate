//
//  Topic.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct Topic: Codable, Equatable {
    let commentCount: Int
    let createdAt: Date
    let id: String
    let replyCount: Int
    let url: URL
    let voteCount: Int
}

// MARK: - Initializers

extension Topic {
    init?(_ topic: TopicType) {
        guard
            let createdAt = DateFormatter.iso8601Full.date(from: topic.createdAt),
            let url = URL(string: topic.url) else {
                return nil
        }

        self.commentCount = topic.commentCount
        self.createdAt = createdAt
        self.id = topic.id
        self.replyCount = topic.replyCount
        self.url = url
        self.voteCount = topic.voteCount
    }

    init?(_ topic: TopicType?) {
        guard let topic = topic else { return nil }
        self.init(topic)
    }
}
