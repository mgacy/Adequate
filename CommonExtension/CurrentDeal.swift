//
//  CurrentDeal.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

public struct CurrentDeal: Codable {
    let id: String
    let title: String
    //let createdAt: Date
    //let updatedAt: Date
    //let imageName: String
    let imageURL: URL // should this be optional?
    let minPrice: Double
    let maxPrice: Double?
    //let priceComparison: String?
    //let isSoldOut: Bool
}

extension CurrentDeal: Equatable {}
