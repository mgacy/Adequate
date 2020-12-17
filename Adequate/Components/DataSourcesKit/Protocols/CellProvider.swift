//
//  CellProvider.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/29/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

public protocol CellFactory {
    associatedtype ViewType // `ContainerView`?
    associatedtype CellType: CellConfigurable

    func cell(for model: CellType.ModelType, in view: ViewType, at indexPath: IndexPath) -> CellType
}

// TODO: add `AsyncCellFactory: CellFactory` with alternate method for cells using asynchronously configured cells
