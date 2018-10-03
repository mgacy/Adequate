//
//  PagedImageViewDataSource.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/3/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class PagedImageViewDataSource: NSObject {

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

    private var urls: [URL] = [URL]()

    // MARK: - A

    func updateImages(with urls: [URL]) {
        self.urls = urls
    }

    func imageSource(for index: Int) -> Promise<UIImage> {
        let imageURL = urls[index]
        let imageSource: Promise<UIImage>
        if let cachedImage = imageService.fetchedImage(for: imageURL) {
            imageSource = Promise<UIImage>(value: cachedImage)
        } else {
            imageSource = imageService.fetchImage(for: imageURL)
        }
        return imageSource
    }

    // MARK: - A

    func numberOfItems() -> Int {
        return urls.count
    }

}
