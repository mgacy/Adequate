//
//  MemoryCache.swift
//  
//
//  Created by Mathew Gacy on 12/27/20.
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

public final class MemoryCache<Key: KeyWrapping, Value: AnyObject>: Caching {

    public var countLimit: Int //= 20
    public var totalCostLimit: Int //= 10*1024*1024 // Max 10MB used.
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

    public init(countLimit: Int = 20, costLimit: Int = 10*1024*1024) {
        self.countLimit = countLimit
        self.totalCostLimit = costLimit
    }

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
extension MemoryCache {
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
//extension MemoryCache: ImageCaching where Key == URL, Value == UIImage {}

// MARK: - Types
extension MemoryCache {

    public struct CacheSize {
        public let megaBytes: Int

        public init(_ megaBytes: Int) {
            self.megaBytes = megaBytes
        }

        var bytes: Int {
            megaBytes*1024*1024
        }

        public static var small: CacheSize {
            Self(10)
        }

        public static var medium: CacheSize {
            return Self(20)
        }
    }
}
