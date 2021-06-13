//
//  FetchOperation.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/11/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import Foundation
import MGNetworking

final class FetchOperation<Request: RequestProtocol>: AsynchronousOperation {
    private let lock: NSLock = NSLock()
    private let networkClient: NetworkClientProtocol
    private let request: Request
    private var networkTask: Resumable?
    private var callbackState: CallbackState

    var fetchResult: FetchResult?

    var response: Request.Response? {
        guard let result = fetchResult, case .success(let response) = result else {
            return nil
        }
        return response
    }

    // MARK: - Initializer

    // TODO: would `resultHandler` be more clear (since `Operation` also has `.completionBlock`?

    init(
        client: NetworkClientProtocol,
        request: Request,
        resultQueue: DispatchQueue = .main,
        completionHandler: Handler?
    ) {
        log.verbose("\(#function)")
        self.networkClient = client
        self.request = request
        self.callbackState = completionHandler != nil ? .single(Callback(resultQueue, completionHandler!)) : .empty
    }

    // MARK: - B

    override func start() {
        if isCancelled {
            state = .finished
            return
        }

        state = .executing
        networkTask = networkClient.send(request) { [weak self] result in
            //log.debug("Fetched: \(result)")
            self?.finish(result)
        }
        networkTask?.resume()
    }

    override func cancel() {
        networkTask?.cancel()
        state = .finished // ?
        super.cancel()
    }

    // MARK: - C

    public func addCallback(_ callback: @escaping Handler, on queue: DispatchQueue = .main) {
        lock.lock(); defer { lock.unlock() }
        let newCallback = Callback(queue, callback)

        switch callbackState {
        case .empty:
            self.callbackState = .single(newCallback)
        case .single(let currentAction):
            self.callbackState = .multiple([currentAction, newCallback])
        case .multiple(let currentActions):
            let newActions = currentActions + [newCallback]
            self.callbackState = .multiple(newActions)
        }
    }

    // MARK: - Utility

    func finish(_ result: FetchResult) {
        lock.lock(); defer { lock.unlock() }
        guard !isCancelled else {
            //state = .finished // ?
            return
        }

        // TODO: check `.isCancelled` again?
        self.fetchResult = result

        let previousState = callbackState
        callbackState = .empty

        switch previousState {
        case .empty:
            break
        case .single(let callback):
            callback.execute(value: result)
        case .multiple(let callbacks):
            callbacks.forEach { $0.execute(value: result)}
        }

        state = .finished
    }
}

// MARK: - Types
extension FetchOperation {
    public typealias FetchResult = Result<Request.Response, NetworkClientError>
    public typealias Handler = (FetchResult) -> Void

    enum CallbackState {
        case empty
        case single(Callback)
        case multiple([Callback])
        //case finished(FetchResult)
        //case cancelled // ?
    }

    struct Callback {
        private let queue: DispatchQueue
        private let block: Handler

        init(_ queue: DispatchQueue = .main, _ block: @escaping Handler) {
            self.queue = queue
            self.block = block
        }

        func execute(value: FetchResult) {
            queue.async {
                self.block(value)
            }
        }
    }
}
