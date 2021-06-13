//
//  NewImageService.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/11/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise
import MGNetworking

// FIXME: how can we clear the cache?
final class NewImageService: ImageServiceType {
    typealias FetchRequest = Request<UIImage>
    typealias FetchResult = Result<UIImage, NetworkClientError>
    typealias Handler = (FetchResult) -> Void

    private let networkClient: NetworkClientProtocol

    private let memoryCache: ImageCaching

    private let diskCache: ImageCaching

    private let serialAccessQueue: OperationQueue = OperationQueue()

    private let fetchQueue: OperationQueue = OperationQueue()

    private var pendingTasks: [URL: FetchOperation<FetchRequest>] = [:]

    // MARK: - Lifecycle

    public init(client: NetworkClientProtocol) {
        self.networkClient = client
        self.memoryCache = MemoryCache<URL, UIImage>()
        self.diskCache = FileCache(fileLocation: AppGroup.currentDeal,
                                   coder: Coder<Any>.makeImageCoder())
        serialAccessQueue.maxConcurrentOperationCount = 1
    }

    deinit {
        log.verbose("\(#function) - \(String(describing: self))")
        self.fetchQueue.cancelAllOperations()
    }

    // MARK: - ImageServiceType

    func fetchedImage(for url: URL, tryingSecondary: Bool = false) -> UIImage? {
        log.verbose("url: \(url) - secondary: \(tryingSecondary)")
        if let result = memoryCache.value(for: url) {
            log.verbose("Primary cache hit for \(url)")
            return result
        } else if tryingSecondary, let file = diskCache.value(for: url) {
            log.verbose("Secondary cache hit for \(url)")
            memoryCache.insert(file, for: url)
            return file
        } else {
            log.verbose("Cache miss for \(url)")
            return nil
        }
    }

    func fetchImage(for url: URL) -> Promise<UIImage> {
        Promise<UIImage>(work: { [weak self] fullfill, reject in
            self?.fetchImage(url) { result in
                switch result {
                case .success(let image):
                    fullfill(image)
                case .failure(let error):
                    reject(error)
                }
            }
        })
    }

    func fetchImage(
        _ url: URL,
        resultQueue: DispatchQueue = .main,
        completionHandler: Handler? = nil
    ) {
        serialAccessQueue.addOperation {
            if let pendingOperation = self.operation(for: url) {
                guard let completionHandler = completionHandler else { return }
                pendingOperation.addCallback(completionHandler, on: resultQueue)
                return
            } else {

                let request = Request<UIImage>(url: url)
                let operation = FetchOperation<FetchRequest>(client: self.networkClient, request: request,
                                                             resultQueue: resultQueue,
                                                             completionHandler: completionHandler)
                operation.completionBlock = { [weak operation] in
                    self.serialAccessQueue.addOperation { self.pendingTasks[url] = nil }
                    guard let image = operation?.response else {
                        return
                    }
                    self.memoryCache.insert(image, for: url)
                }

                self.pendingTasks[url] = operation
                self.fetchQueue.addOperation(operation)
            }
        }
    }

    func clearCache() {
        memoryCache.removeAll()
        //if clearSecondary {
        //    diskCache.removeAll()
        //}
    }

    // MARK: - PrefetchingImageServiceType

    func prefetchImage(for url: URL) {
        fetchImage(url, resultQueue: .main, completionHandler: nil)
    }

    func cancelFetch(for url: URL) {
        serialAccessQueue.addOperation {
            self.fetchQueue.isSuspended = true
            defer {
                self.fetchQueue.isSuspended = false
            }

            self.operation(for: url)?.cancel()
        }
    }

    // MARK: - Private

    private func operation(for url: URL) -> FetchOperation<FetchRequest>? {
        // TODO: would we need to halt fetchQueue?
        //fetchQueue.isSuspended = true // ?
        //defer {
        //    fetchQueue.isSuspended = false
        //}
        guard let operation = pendingTasks[url], !operation.isCancelled else {
            return nil
        }
        return operation
    }
}
