//
//  RefreshManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 5/13/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import AWSAppSync

final class RefreshManager: NSObject {

    private let dateProvider: () -> Date
    private let minimumRefreshInterval: TimeInterval = 60

    // TODO: initialize with UserDefaultsManager; use AppGroup
    private let defaults: UserDefaults = .standard

    var cacheCondition: CacheCondition {
        // Can we rely on the cache?
        // FIXME: when using this for `RefreshEvent.foreground`, we should also see how long since last refresh
        if case .available = UIApplication.shared.backgroundRefreshStatus {
            if lastDealResponse.timeIntervalSince(lastDealRequest) >= 0 {
                // Our last request succeeded
                // TODO: verify that Date().timeIntervalSince(lastDealCreatedAt) < 24 hours
                return .fresh // showLoading: false - cachePolicy: .returnCacheDataAndFetch
            } else {
                // Our last request failed
                // FIXME: the fact that the last fetch failed does not necessarily mean that the cache is outdated since that fetch could have been triggered by a `.foreground` event; if it was a `DealDelta`, the cache is not entirely worthless, either
                return .stale // showLoading: true - cachePolicy: .fetchIgnoringCacheData
            }
        } else {
            log.debug("backgroundRefreshStatus: \(UIApplication.shared.backgroundRefreshStatus)")
            return .intermediate // showLoading: false - cachePolicy: fetchIgnoringCacheData
        }
    }

    /// The last time we tried to fetch the current Deal (in response to Notification)
    // TODO: replace with property wrapper
    // https://medium.com/@kahseng.lee123/create-the-perfect-userdefaults-wrapper-using-property-wrapper-42ca76005ac8
    private var lastDealRequest: Date {
        get {
            return defaults.object(forKey: UserDefaultsKey.lastDealRequest.rawValue) as? Date ?? Date.distantPast
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.lastDealRequest.rawValue)
        }
    }

    /// The last time we succeeded in fetching the current Deal
    private var lastDealResponse: Date {
        get {
            return defaults.object(forKey: UserDefaultsKey.lastDealResponse.rawValue) as? Date ?? Date.distantPast
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.lastDealResponse.rawValue)
        }
    }
    /*
    /// The .createdAt of last Deal fetched from server
    private var lastDealCreatedAt: Date {
        get {
            return defaults.object(forKey: UserDefaultsKey.lastDealCreatedAt.rawValue) as? Date ?? Date.distantPast
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.lastDealCreatedAt.rawValue)
        }
    }
    */

    var backgroundRefreshStatus: UIBackgroundRefreshStatus {
        return UIApplication.shared.backgroundRefreshStatus
    }

    // MARK: - Lifecycle

    init(dateProvider: @escaping () -> Date = Date.init) {
        self.dateProvider = dateProvider
    }

    // TODO: improve naming
    func update(_ event: Event) {
        switch event {
        case .request:
            lastDealRequest = dateProvider()
        case .response:
            lastDealResponse = dateProvider()
            //if let topic = deal.topic {
            //    self.lastDealCreatedAt = topic.createdAt
            //}
        }
    }
}

// MARK: - Types
extension RefreshManager {

    enum Event {
        case request
        //case update(DealDelta)
        // TODO: pass both `oldDeal: Deal?` and `newDeal: Deal`?
        case response(Deal)
    }

    enum CacheCondition {
        case fresh          // showLoading: false, cachePolicy: returnCacheDataAndFetch?
        case intermediate   // showLoading: false, cachePolicy: fetchIgnoringCacheData
        case stale          // showLoading: true,  cachePolicy: fetchIgnoringCacheData

        var cachePolicy: CachePolicy {
            switch self {
            case .fresh: return .returnCacheDataAndFetch
            case .intermediate: return .returnCacheDataAndFetch
            case .stale: return .fetchIgnoringCacheData
            }
        }

        var showLoading: Bool {
            switch self {
            case .fresh: return false
            case .intermediate: return false
            case .stale: return true
            }
        }
    }
}
