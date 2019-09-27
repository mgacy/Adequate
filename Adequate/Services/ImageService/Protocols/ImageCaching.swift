//
//  ImageCaching.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public protocol ImageCaching {
    func saveImageToCache(image: UIImage?, url: URL)
    func imageFromCache(for: URL) -> UIImage?
    func clearCache()
}
