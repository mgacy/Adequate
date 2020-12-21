//
//  Poll.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

public struct Poll: Codable, Equatable {

    public struct Answer: Codable, Equatable {
        public let id: String
        public let text: String
        public let voteCount: Int
    }

    public let answers: [Answer]
    public let id: String
    public let startDate: Date
    public let title: String
    public let topic: Topic?
}
