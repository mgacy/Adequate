//
//  RefreshEventQueue.swift
//  Adequate
//
//  Created by Mathew Gacy on 5/13/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import Foundation

protocol RefreshEventQueueType {
    var isEmpty: Bool { get }
    var peek: RefreshEvent? { get }

    func push(_: RefreshEvent)
    func pop() -> RefreshEvent?
}

final class RefreshEventQueue: RefreshEventQueueType {

    private var pendingRefreshEvent: RefreshEvent?

    public init() {}

    // MARK: - RefreshEventQueueType

    var isEmpty: Bool {
        return pendingRefreshEvent == nil
    }

    var peek: RefreshEvent? {
        return pendingRefreshEvent
    }

    func push(_ refreshEvent: RefreshEvent) {
        if pendingRefreshEvent != nil {
            log.warning("Replacing pendingRefreshEvent '\(pendingRefreshEvent!)' with '\(refreshEvent)'")
        }
        pendingRefreshEvent = refreshEvent
    }

    func pop() -> RefreshEvent? {
        guard let refreshEvent = pendingRefreshEvent else {
            return nil
        }
        pendingRefreshEvent = nil
        return refreshEvent
    }
}
