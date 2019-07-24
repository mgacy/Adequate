//
//  CompletionWrapper.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

// TODO: is this essentially a Future?
class CompletionWrapper<T> {
    private let wrappedHandler: (T) -> Void
    private let onCompletion: () -> Void

    var observationToken: ObservationToken?

    init(wrapping handler: @escaping (T) -> Void, onCompletion: @escaping () -> Void) {
        self.wrappedHandler = handler
        self.onCompletion = onCompletion
    }

    deinit {
        log.debug("Deinit \(self)")
        observationToken?.cancel()
    }

    // MARK: Public

    func complete(with value: T) {
        defer { onCompletion() }
        wrappedHandler(value)
    }
}
