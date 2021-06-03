//
//  PagedImageViewDataSource.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/3/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise
import enum MGNetworking.NetworkClientError

// MARK: - Protocol

 protocol PagedImageViewDataSourceType: Themeable {
     func addDataSource(toCollectionView: UICollectionView)
     func update(with: [URL], animatingDifferences: Bool, completion: (() -> Void)?)
     func imageSource(for indexPath: IndexPath) -> Promise<UIImage>
 }

// MARK: - Implementation

final class PagedImageViewDataSource: NSObject, PagedImageViewDataSourceType {

    private let imageService: ImageServiceType

    private var theme: ColorTheme?
    // TODO: should we just initialize with UICollectionView and make this implicitly unwrapped?
    private var dataSource: UICollectionViewDiffableDataSource<SingleSection, URL>?

    // MARK: - Lifecycle

    convenience init(imageService: ImageServiceType, collectionView: UICollectionView) {
        self.init(imageService: imageService)
        addDataSource(toCollectionView: collectionView)
    }

    init(imageService: ImageServiceType) {
        self.imageService = imageService
    }

    // MARK: - PagedImageViewDataSourceType

    func update(with new: [URL], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        let snapshot = SingleSection.makeSnapshot(for: new)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func imageSource(for indexPath: IndexPath) -> Promise<UIImage> {
        guard let imageURL = dataSource?.itemIdentifier(for: indexPath) else {
            // FIXME: use better error; add error type for data source?
            let error = NetworkClientError.unknown(message: "Missing URLs")
            return Promise<UIImage>(error: error)
        }
        if let cachedImage = imageService.fetchedImage(for: imageURL, tryingSecondary: indexPath.row == 0) {
            return Promise<UIImage>(value: cachedImage)
        } else {
            return imageService.fetchImage(for: imageURL)
        }
    }
}

// MARK: - Configuration
extension PagedImageViewDataSource {

    func addDataSource(toCollectionView collectionView: UICollectionView) {
        self.dataSource = makeDataSource(for: collectionView)
        collectionView.dataSource = dataSource
        dataSource?.apply(SingleSection.makeSnapshot(for: [URL]()),
                          animatingDifferences: false)
    }

    func makeDataSource(
        for collectionView: UICollectionView
    ) -> UICollectionViewDiffableDataSource<SingleSection, URL> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, imageURL in
                let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.modelID = imageURL
                cell.delegate = self

                // TODO: have cell observe data source for theme changes?
                if let theme = self?.theme {
                    cell.apply(theme: theme)
                }
                // swiftlint:disable:next line_length
                if let cachedImage = self?.imageService.fetchedImage(for: imageURL, tryingSecondary: indexPath.row == 0) {
                    cell.configure(with: Promise<UIImage>(value: cachedImage))
                } else if let imageService = self?.imageService {
                    cell.configure(with: imageService.fetchImage(for: imageURL))
                }

                return cell
            })
    }
}

// MARK: - ImageCellDelegate
extension PagedImageViewDataSource: ImageCellDelegate {
    func retry(imageURL: URL) -> Promise<UIImage> {
       return imageService.fetchImage(for: imageURL)
    }
}

// MARK: - Themeable
extension PagedImageViewDataSource: Themeable {
    func apply(theme: ColorTheme) {
        // FIXME: apply theme to cells; have them observe data source?
        self.theme = theme
    }
}
