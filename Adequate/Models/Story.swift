//
//  Story.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct Story: Codable, Equatable {
    let title: String
    let body: String
}

// MARK: - Initializers

extension Story {
    init(_ story: StoryType) {
        self.title = story.title
        self.body = story.body
    }

    init?(_ story: StoryType?) {
        guard let story = story else { return nil }
        self.init(story)
    }
}
