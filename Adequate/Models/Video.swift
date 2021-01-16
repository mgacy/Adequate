//
//  Video.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

public struct Video: Codable, Equatable {
    public let id: String
    public let startDate: Date
    public let title: String
    public let url: URL
    public let topic: Topic?
}
