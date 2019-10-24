//
//  MehResponse.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

struct MehResponse: Codable, Equatable {
    let deal: Deal
    let poll: Poll?
    let video: Video?
}
