//
//  Models.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/29/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

/// Model for diffable data sources with a single section.
public enum SingleSection: CaseIterable {
    case main

    public static func makeSnapshot<T: Hashable>(for updated: [T]) -> NSDiffableDataSourceSnapshot<Self, T> {
        var snapshot = NSDiffableDataSourceSnapshot<Self, T>()
        snapshot.appendSections([.main])
        snapshot.appendItems(updated, toSection: .main)
        return snapshot
    }
}
