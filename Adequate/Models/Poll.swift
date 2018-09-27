//
//  Poll.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct Poll: Codable {

    struct Answer: Codable {
        let id: String
        let text: String
        let voteCount: Int
    }

    let answers: [Answer]
    let id: String
    let startDate: Date
    let title: String
    let topic: Topic?
}
