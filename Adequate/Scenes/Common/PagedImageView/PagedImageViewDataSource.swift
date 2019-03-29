//
//  PagedImageViewDataSource.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/3/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class PagedImageViewDataSource: NSObject, UICollectionViewDataSource {

    lazy var imageService: ImageService = {
        // Configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20  // seconds
        configuration.timeoutIntervalForResource = 20 // seconds
        configuration.waitsForConnectivity = true     // reachability

        // JSON Decoding
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

        let client = NetworkClient(configuration: configuration, decoder: decoder)
        let service = ImageService(client: client)
        return service
    }()

    private var theme: AppTheme?
    private var urls: [URL] = [URL]()

    // MARK: - A

    func updateImages(with urls: [URL]) {
        self.urls = urls
    }

    func imageSource(for indexPath: IndexPath) -> Promise<UIImage> {
        let imageURL = urls[indexPath.row]
        let imageSource: Promise<UIImage>
        if let cachedImage = imageService.fetchedImage(for: imageURL) {
            imageSource = Promise<UIImage>(value: cachedImage)
        } else {
            imageSource = imageService.fetchImage(for: imageURL)
        }
        return imageSource
    }

    // MARK: - UICollectionViewDataSource

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
        //cell.delegate = self

        if let cachedImage = imageService.fetchedImage(for: imageURL) {
            cell.configure(with: cachedImage)
        } else {
            cell.configure(with: imageService.fetchImage(for: imageURL))
        }
        return cell
    }

}

// MARK: - Themeable
extension PagedImageViewDataSource: Themeable {
    func apply(theme: AppTheme) {
        self.theme = theme
    }
}
