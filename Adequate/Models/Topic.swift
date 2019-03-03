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
