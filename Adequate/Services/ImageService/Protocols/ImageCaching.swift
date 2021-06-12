//
//  ImageCaching.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import class MGNetworking.MemoryCache

public protocol ImageCaching {
    func insert(_: UIImage, for: URL)
    func value(for: URL) -> UIImage?
    func removeValue(for: URL)
    func removeAll()
}

// MARK: - MemoryCache+ImageCaching
extension MemoryCache: ImageCaching where Key == URL, Value == UIImage {}
