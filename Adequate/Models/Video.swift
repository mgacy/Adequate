//
//  Video.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct Video: Codable, Equatable {
    let id: String
    let startDate: Date
    let title: String
    let url: URL
    let topic: Topic?
}
