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

    func insert(_ value: UIImage, for key: URL) {
        cache[key.absoluteString] = value
    }

    func value(for key: URL) -> UIImage? {
        return cache[key.absoluteString]
    }

    func removeValue(for key: URL) {
        cache[key.absoluteString] = nil
    }

    func removeAll() {
        cache.removeAll()
    }
}
