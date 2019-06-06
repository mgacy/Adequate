//
//  FileCache.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class FileCache {

    let maxFileCount: Int = 5

    private let fileManager: FileManager = .default
    private let sharedContainerURL: URL

    // MARK: - Lifecycle

    init(appGroupID: String){
        let appGroupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!
        self.sharedContainerURL = appGroupURL.appendingPathComponent("Library/Caches", isDirectory: true)

        // TODO: should this just maintain an array of files to minimize file operations?
        //let currentFiles = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: .skipsHiddenFiles)
        //self.files = currentFiles
    }

    // MARK: - Write

    func saveImageToCache(image: UIImage?, url: URL) {

        // FIXME: ensure no illegal name characters?
        // FIXME: we are discarding a lot of info that could, theoretically, be significant
        let fileName = url.lastPathComponent
        let destinationURL = sharedContainerURL.appendingPathComponent(fileName)

        guard let image = image else {
            do {
                try fileManager.removeItem(at: destinationURL)
            } catch {
                log.error("Error clearing image: \(error)")
            }
            return
        }

        guard let data = image.pngData() else {
            log.error("Error getting pngData from image")
            return
        }

        /// Write file
        do {
            /// Ensure caches directory exists
            try fileManager.createDirectory(at: sharedContainerURL, withIntermediateDirectories: true, attributes: nil)

            /// Rewrite or just skip if file already exists?
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try data.write(to: destinationURL)
        } catch {
            log.error("Error writing image: \(error)")
        }

        /// Cleanup cache
        do {
            try cleanupCache()
        } catch {
            //print("Error cleaning up cache: ", error)
            log.error("Error cleaning up cache: \(error)")
        }
    }

    // MARK: - Read

    func imageFromCache(for url: URL) -> UIImage? {
        let fileName = url.lastPathComponent
        var imageData: Data?
        do {
            imageData = try Data(contentsOf: sharedContainerURL.appendingPathComponent(fileName))
        } catch {
            log.error("Error reading image data: \(error)")
        }
        guard let data = imageData else {
            return nil
        }
        return UIImage(data: data)
    }

    // MARK: - Maintenance

    /// Purge oldest items if number of files > maxFileCount
    private func cleanupCache() throws {
        if let files = try markFilesForDeletion(at: sharedContainerURL, maxFileCount: maxFileCount) {
            for file in files {
                try fileManager.removeItem(at: file)
            }
        }
    }

    /// Remove all items
    func clearCache() throws {
        if let files = try markFilesForDeletion(at: sharedContainerURL, maxFileCount: 0) {
            for file in files {
                try fileManager.removeItem(at: file)
            }
        }
    }

    // MARK: - Private

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
