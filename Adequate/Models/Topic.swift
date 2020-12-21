//
//  Topic.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

// sourcery: lens
public struct Topic: Codable, Equatable {
    public let commentCount: Int
    public let createdAt: Date
    public let id: String
    //public let replyCount: Int
    public let url: URL
    //public let voteCount: Int
}

// MARK: - Initializers

public extension Topic {
    init?(_ topic: TopicType) {
        guard
            let createdAt = DateFormatter.iso8601Full.date(from: topic.createdAt),
            let url = URL(string: topic.url) else {
                return nil
        }

        self.commentCount = topic.commentCount
        self.createdAt = createdAt
        self.id = topic.id
        //self.replyCount = topic.replyCount
        self.url = url
        //self.voteCount = topic.voteCount
    }

    init?(_ topic: TopicType?) {
        guard let topic = topic else { return nil }
        self.init(topic)
    }
}
