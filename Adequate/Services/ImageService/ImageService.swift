//
//  ImageService.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

public class ImageService: ImageServiceType {

    private let memoryCache: ImageCaching
    private let diskCache: ImageCaching
    private let client: NetworkClientType
    /*
    struct Task {
        let promise: Promise<UIImage>
        // TODO: initialize with background queue?
        let queue = InvalidatableQueue()
    }
    */
    // TODO: do we need to handle caching or removal of pending tasks on a lockQueue?
    //private let lockQueue = DispatchQueue(label: "image_service_lock_queue", qos: .userInitiated)
    private var pendingTasks = Dictionary<String, Promise<UIImage>>()
    //private var pendingTasks = Dictionary<String, Task>()

    public init(client: NetworkClientType) {
        self.client = client
        self.memoryCache = Cache<URL, UIImage>()
        self.diskCache = FileCache(appGroupID: "group.mgacy.com.currentDeal")
    }

    /*
     https://github.com/khanlou/Promise
     Warning: don't chain blocks off anything that is executing on an invalidatable queue. then blocks that return Void
     won't stop the chain, but then blocks that return values or promises will stop the chain. Because the block can't
     be executed, the result of the next value in the chain won't be calculable, and the next promise will remain in the
     pending state forever, preventing resources from being released.
     */

    // TODO: pass InvalidatableQueue as well?
    //@discardableResult
    public func fetchImage(for url: URL) -> Promise<UIImage> {
        if let pendingFetch = pendingTasks[url.absoluteString] {
            return pendingFetch
        } else {
            // TODO: do this on background thread / lockQueue?
            let promise: Promise<UIImage> = client.request(url).then({ [weak self] image in
                self?.memoryCache.insert(image, for: url)
            }).always({ [weak self] in
                self?.pendingTasks[url.absoluteString] = nil
            })
            pendingTasks[url.absoluteString] = promise
            return promise
        }
    }

    public func fetchedImage(for url: URL, tryingSecondary: Bool = false) -> UIImage? {
        //log.debug("url: \(url) - secondary: \(tryingSecondary)")
        if let result = memoryCache.value(for: url) {
            //log.verbose("Primary Cache")
            return result
        } else if tryingSecondary, let file = diskCache.value(for: url) {
            //log.verbose("Found image for \(url) in diskCache")
            memoryCache.insert(file, for: url)
            return file
        } else {
            //log.verbose("Neither Cache")
            return nil
        }
    }
    /*
    public func cancelFetch(_ url: URL) {
        // TODO: does any of this need to be performed on the lockQueue?
        // TODO: add guard?
        let task = pendingTasks[url.absoluteString]
        task.queue.invalidate()
        pendingTasks[url.absoluteString] = nil
    }
    */
    public func clearCache() {
        memoryCache.removeAll()
        // TODO: `diskCache.removeAll()`?
    }
}
