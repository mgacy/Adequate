//
//  Cache.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public protocol KeyWrapping {
    associatedtype Key: AnyObject & Hashable
    var key: Key { get }
}

extension URL: KeyWrapping {
    public typealias Key = NSString
    public var key: Key {
        return absoluteString as NSString
    }
}

public final class Cache<Key: KeyWrapping, Value: AnyObject>: Caching {

    public var countLimit: Int = 20
    public var totalCostLimit: Int = 10*1024*1024 // Max 10MB used.
    public var delegate: NSCacheDelegate? {
        didSet {
            wrapped.delegate = delegate
        }
    }

    private lazy var wrapped: NSCache<Key.Key, Value> = {
        let cache = NSCache<Key.Key, Value>()
        //cache.name = "com.mgacy.x"
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
        return cache
    }()

    //init(countLimit: Int = 20, costLimit: Int = 10*1024*1024) {}

    // MARK: - Caching

    public func insert(_ value: Value, for key: Key) {
        wrapped.setObject(value, forKey: key.key)
    }

    public func value(for key: Key) -> Value? {
        return wrapped.object(forKey: key.key)
    }

    public func removeValue(for key: Key) {
        wrapped.removeObject(forKey: key.key)
    }

    public func removeAll() {
        wrapped.removeAllObjects()
    }
}

// MARK: - Subscripts
extension Cache {
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

// MARK: - ImageCaching
extension Cache: ImageCaching where Key == URL, Value == UIImage {}
