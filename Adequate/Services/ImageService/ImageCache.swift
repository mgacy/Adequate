//
//  ImageCache.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class ImageCache: ImageCaching {

    var cache = Dictionary<String, UIImage>()

    func saveImageToCache(image: UIImage?, url: URL) {
        guard let image = image else { return }
        cache[url.absoluteString] = image
    }

    func imageFromCache(for url: URL) -> UIImage? {
        return cache[url.absoluteString]
    }

    func clearCache() {
        cache.removeAll()
    }
}
