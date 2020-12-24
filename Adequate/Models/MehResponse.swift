//
//  MehResponse.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

public struct MehResponse: Codable, Equatable {
    public let deal: Deal
    public let poll: Poll?
    public let video: Video?
}
