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

// MARK: - Lens

extension Topic {
    enum lens {
        static let commentCount = Lens<Topic, Int>(
            get: { $0.commentCount },
            set: { part in
                { whole in
                    Topic.init(commentCount: part, createdAt: whole.createdAt, id: whole.id, replyCount: whole.replyCount, url: whole.url, voteCount: whole.voteCount)
                }
        }
        )
        static let createdAt = Lens<Topic, Date>(
            get: { $0.createdAt },
            set: { part in
                { whole in
                    Topic.init(commentCount: whole.commentCount, createdAt: part, id: whole.id, replyCount: whole.replyCount, url: whole.url, voteCount: whole.voteCount)
                }
        }
        )
        static let id = Lens<Topic, String>(
            get: { $0.id },
            set: { part in
                { whole in
                    Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: part, replyCount: whole.replyCount, url: whole.url, voteCount: whole.voteCount)
                }
        }
        )
        static let replyCount = Lens<Topic, Int>(
            get: { $0.replyCount },
            set: { part in
                { whole in
                    Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: whole.id, replyCount: part, url: whole.url, voteCount: whole.voteCount)
                }
        }
        )
        static let url = Lens<Topic, URL>(
            get: { $0.url },
            set: { part in
                { whole in
                    Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: whole.id, replyCount: whole.replyCount, url: part, voteCount: whole.voteCount)
                }
        }
        )
        static let voteCount = Lens<Topic, Int>(
            get: { $0.voteCount },
            set: { part in
                { whole in
                    Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: whole.id, replyCount: whole.replyCount, url: whole.url, voteCount: part)
                }
        }
        )
    }
}
