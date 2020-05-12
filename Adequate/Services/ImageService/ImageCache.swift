//
//  ImageCache.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public class ImageCache: ImageCaching {
    public typealias Key = URL
    public typealias Value = UIImage // TODO: use UIImage or Data?

    public var countLimit: Int = 20
    public var totalCostLimit: Int = 10*1024*1024 // Max 10MB used.
    public var delegate: NSCacheDelegate? {
        didSet {
            wrapped.delegate = delegate
        }
    }

    private lazy var wrapped: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        //cache.name = "com.mgacy.x"
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
        return cache
    }()

    //init() { }

    public func insert(_ value: Value, for key: Key) {
        wrapped.setObject(value, forKey: key.absoluteString as NSString)
    }

    public func value(for key: Key) -> Value? {
        return wrapped.object(forKey: key.absoluteString as NSString)
    }

    public func removeValue(for key: Key) {
        wrapped.removeObject(forKey: key.absoluteString as NSString)
    }

    public func removeAll() {
        wrapped.removeAllObjects()
    }
}

// MARK: - Subscripts
extension ImageCache {
    public subscript(key: Key) -> Value? {
        get { return value(for: key) }
        set {
            guard let value = newValue else {
                removeValue(for: key)
                return
            }
            insert(value, for: key)
        }
    }
}

