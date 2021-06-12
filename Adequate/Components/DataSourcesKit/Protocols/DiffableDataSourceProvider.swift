//
//  DiffableDataSourceProvider.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/29/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - UITableView
public typealias TableCellConfigurable = CellConfigurable & UITableViewCell

public protocol TableViewDiffableDataSourceProvider {
    associatedtype CellType: TableCellConfigurable
    associatedtype SectionType: Hashable & CaseIterable
    associatedtype ItemType: Hashable

    func makeDataSource(
        for: UITableView
    ) -> UITableViewDiffableDataSource<SectionType, ItemType>
}

public extension TableViewDiffableDataSourceProvider where CellType.ModelType == ItemType {

    /// NOTE: this doesn't help when the model is used to fetch resources asynchronously.
    func makeDataSource(
        for tableView: UITableView
    ) -> UITableViewDiffableDataSource<SectionType, ItemType> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, model in
                let cell: CellType = tableView.dequeueReusableCell(for: indexPath)
                cell.configure(with: model)
                return cell
            }
        )
    }
}

// MARK: - UICollectionView
public typealias CollectionCellConfigurable = CellConfigurable & UICollectionViewCell

public protocol CollectionViewDiffableDataSourceProvider {
    associatedtype CellType: CollectionCellConfigurable
    associatedtype SectionType: Hashable & CaseIterable
    associatedtype ItemType: Hashable

    func makeDataSource(
        for: UICollectionView
    ) -> UICollectionViewDiffableDataSource<SectionType, ItemType>
}

public extension CollectionViewDiffableDataSourceProvider where CellType.ModelType == ItemType {

    /// NOTE: this doesn't help when the model is used to fetch resources asynchronously.
    func makeDataSource(
        for collectionView: UICollectionView
    ) -> UICollectionViewDiffableDataSource<SectionType, ItemType> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, model in
                let cell: CellType = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: model)
                return cell
            })
    }
}
