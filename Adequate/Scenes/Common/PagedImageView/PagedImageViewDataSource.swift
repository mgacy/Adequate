//
//  PagedImageViewDataSource.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/3/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

// MARK: - Protocol

protocol PagedImageViewDataSourceType: UICollectionViewDataSource, Themeable {
    func updateImages(with urls: [URL])
    func imageSource(for indexPath: IndexPath) -> Promise<UIImage>
}

// MARK: - Implementation

class PagedImageViewDataSource: NSObject, PagedImageViewDataSourceType {

    private let imageService: ImageServiceType

    private var theme: AppTheme?
    private var urls: [URL] = [URL]()

    // MARK: - Lifecycle

    init(imageService: ImageServiceType) {
        self.imageService = imageService
    }

    // MARK: - PagedImageViewDataSourceType

    func updateImages(with urls: [URL]) {
        self.urls = urls
    }

    func imageSource(for indexPath: IndexPath) -> Promise<UIImage> {
        let imageURL = urls[indexPath.row]
        let imageSource: Promise<UIImage>
        if let cachedImage = imageService.fetchedImage(for: imageURL, tryingSecondary: indexPath.row == 0) {
            imageSource = Promise<UIImage>(value: cachedImage)
        } else {
            imageSource = imageService.fetchImage(for: imageURL)
        }
        return imageSource
    }
}

// MARK: - UICollectionViewDataSource
extension PagedImageViewDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
        let imageURL = urls[indexPath.row]

        cell.imageURL = imageURL
        if let theme = theme {
            cell.apply(theme: theme)
        }
        cell.delegate = self

        if let cachedImage = imageService.fetchedImage(for: imageURL, tryingSecondary: indexPath.row == 0) {
            cell.configure(with: Promise<UIImage>(value: cachedImage))
        } else {
            cell.configure(with: imageService.fetchImage(for: imageURL))
        }
        return cell
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
    func apply(theme: AppTheme) {
        self.theme = theme
    }
}
