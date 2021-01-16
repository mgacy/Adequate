//
//  PriceRange.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/13/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

public enum PriceRange {
    case none
    case single(Double)
    case range(min: Double, max: Double)
}
