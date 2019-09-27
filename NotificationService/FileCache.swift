//
//  FileCache.swift
//  NotificationService
//
//  Created by Mathew Gacy on 6/6/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class FileCache {

    let maxFileCount: Int = 5

    private let fileManager: FileManager = .default
    private let containerURL: URL

    // MARK: - Lifecycle

    init(appGroupID: AppGroupID){
        let appGroupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID.rawValue)!
        self.containerURL = appGroupURL.appendingPathComponent("Library/Caches", isDirectory: true)
    }

    // MARK: - Write

    /// Copy file at `url` into cache
    public func storeFile(at url: URL, as fileName: String) {
        // TODO: ensure no illegal characters in fileName?

        let destinationURL = containerURL.appendingPathComponent(fileName)
        do {
            // Ensure caches directory exists
            try fileManager.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: url, to: destinationURL)
        } catch {
            print("Error writing file: ", error)
        }

        do {
            try cleanupCache()
        } catch {
            print("Error cleaning up cache: ", error)
        }
    }

    // MARK: - Maintenance

    /// Remove all items from cache.
    func clearCache() throws {
        if let files = try markFilesForDeletion(at: containerURL, maxFileCount: 0) {
            for file in files {
                try fileManager.removeItem(at: file)
            }
        }
    }

    // MARK: - Private

    /// Purge oldest items if number of files in cache > maxFileCount
    private func cleanupCache() throws {
        if let files = try markFilesForDeletion(at: containerURL, maxFileCount: maxFileCount) {
            for file in files {
                try fileManager.removeItem(at: file)
            }
        }
    }

    /// Returns the oldest cached files that should be deleted.
    /// - Parameter url: The `URL` of the cached files to be pruned.
    /// - Parameter maxFileCount: The maximum desired number of files to cache.
    ///
    /// When `containerURL` contains n files and n > `maxFileCount`, return Array of URLs for the n - `maxFileCount` oldest files.
    private func markFilesForDeletion(at url: URL, maxFileCount: Int) throws -> [URL]? {
        let keys = [URLResourceKey.creationDateKey]
        let currentFiles = try fileManager.contentsOfDirectory(at: url,
                                                               includingPropertiesForKeys: keys,
                                                               options: .skipsHiddenFiles)

        if currentFiles.count > maxFileCount {
            let sorted = try currentFiles.sorted(by: {
                let lhs = try $0.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                let rhs = try $1.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                return lhs.compare(rhs) == .orderedDescending
            })
            return Array(sorted[maxFileCount ..< sorted.endIndex])
        } else {
            return nil
        }
    }
}
