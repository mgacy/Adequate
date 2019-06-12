//
//  TopicType.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/12/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

protocol TopicType {
    var commentCount: Int { get }
    var createdAt: String { get }
    var id: String { get }
    var replyCount: Int { get }
    var url: String { get }
    var voteCount: Int { get }
}
