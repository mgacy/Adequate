//
//  CellConfigurable.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/28/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

/// Use to configure a `UITableViewCell` or `UICollectionViewCell` with an instance of `ModelType`.
public protocol CellConfigurable {
    associatedtype ModelType
    func configure(with: ModelType)
}

/// Use when a data source's model is used to fetch `ModelType`
public protocol AsyncCellConfigurable: CellConfigurable {
    associatedtype ModelIdentifierType: Hashable

    /// Identifier for the fetched resource that will be used to configure cell
    ///
    /// Before calling `configure(with:)`, verify that cell has not been recycled to represent other data
    /// by comparing the identifier used to fetch the instance of `ModelType` with `modelID`
    var modelID: ModelIdentifierType? { get set }
}
