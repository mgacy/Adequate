//
//  FileCache.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class FileCache: ImageCaching {

    let maxFileCount: Int = Constants.maxFileCount

    private let fileManager: FileManager = .default
    private let containerURL: URL

    // MARK: - Lifecycle

    init(appGroupID: String){
        let appGroupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!
        self.containerURL = appGroupURL.appendingPathComponent(Constants.cacheDirectory, isDirectory: true)

        // TODO: should this just maintain an array of files to minimize file operations?
        //let currentFiles = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: .skipsHiddenFiles)
        //self.files = currentFiles
    }

    // MARK: - Write

    func insert(_ value: UIImage, for key: URL) {

        // FIXME: ensure no illegal name characters?
        // FIXME: we are discarding a lot of info that could, theoretically, be significant
        let fileName = key.lastPathComponent
        let destinationURL = containerURL.appendingPathComponent(fileName)

        guard let data = value.pngData() else {
            log.error("Error getting pngData from image")
            return
        }

        // Write file
        do {
            // Ensure caches directory exists
            try fileManager.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)

            // Rewrite or just skip if file already exists?
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try data.write(to: destinationURL)
        } catch {
            log.error("Error writing image: \(error)")
        }

        // Cleanup cache
        do {
            try cleanupCache()
        } catch {
            log.error("Error cleaning up cache: \(error)")
        }
    }

    func removeValue(for key: URL) {
        let fileName = key.lastPathComponent
        let destinationURL = containerURL.appendingPathComponent(fileName)

        do {
            try fileManager.removeItem(at: destinationURL)
        } catch {
            log.error("Error clearing image: \(error)")
        }
    }

    // MARK: - Read

    func value(for key: URL) -> UIImage? {
        let fileName = key.lastPathComponent
        var imageData: Data?
        do {
            imageData = try Data(contentsOf: containerURL.appendingPathComponent(fileName))
        } catch {
            guard (error as NSError).code != NSFileReadNoSuchFileError else { return nil }
            log.error("Error reading image data: \(error)")
        }
        guard let data = imageData else {
            log.verbose("Failed to retrieve image for \(key)")
            return nil
        }
        //log.verbose("Succeeded in retrieving image for \(key)")
        // TODO: make more generic; just return Data and have other components handle UIImage
        return UIImage(data: data)
    }

    // MARK: - Maintenance

    /// Remove all items from cache.
    func removeAll() {
        do {
            if let files = try markFilesForDeletion(at: containerURL, maxFileCount: 0) {
                for file in files {
                    try fileManager.removeItem(at: file)
                }
            }
        } catch {
            log.error("Error clearing cache: \(error)")
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

// MARK: - Types
extension FileCache {

    // TODO: make `struct Config` and initialize?
    enum Constants {
        static var cacheDirectory: String = "Library/Caches"
        static var maxFileCount: Int = 5
    }
}
