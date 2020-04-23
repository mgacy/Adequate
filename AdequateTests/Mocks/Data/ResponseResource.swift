//
//  ResponseResource.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/21/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

enum ResponseResource: String {
    case currentDeal
    case historyList
    case historyDetail

    /// File type (not yet used)
    var resourceType: String {
        return "json"
    }
}
