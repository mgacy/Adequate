//
//  FileCache.swift
//  
//
//  Created by Mathew Gacy on 12/26/20.
//

import Foundation

public final class FileCache<T>: Caching {

    let maxFileCount: Int

    private let fileManager: FileManager = .default

    private let fileLocation: FileLocation

    private var containerURL: URL? {
        return fileLocation.containerURL
    }

    private let coder: Coder<T>

    // MARK: - Lifecycle

    public init(fileLocation: FileLocation, coder: Coder<T>, maxFileCount: Int = 5) {
        self.maxFileCount = maxFileCount
        self.fileLocation = fileLocation
        self.coder = coder

        // TODO: should this just maintain an array of files to minimize file operations?
        //let currentFiles = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: .skipsHiddenFiles)
        //self.files = currentFiles
    }

    // MARK: - Write

    public func insert(_ value: T, for key: URL) {
        // FIXME: we are discarding the image dimensions which are contained in the URL
        guard let containerURL = containerURL else { return }
        let destinationURL = containerURL.appendingPathComponent(key.lastPathComponent)
        let data: Data
        do {
            data = try coder.encode(value)
        } catch {
            //log?.error("Error getting data from \(value): \(error)")
            return
        }

        var error: NSError?
        NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: destinationURL,
                                                         options: .forReplacing,
                                                         error: &error) { url in
            // Write file
            do {
                // Ensure caches directory exists
                try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true,
                                                attributes: nil)

                // Overwrite or just skip if file already exists?
                //if fileManager.fileExists(atPath: url.path) {
                //    return
                //}
                try data.write(to: url)
            } catch {
                //log?.error("Error writing image: \(error)")
            }

            // Cleanup cache
            do {
                try cleanupCache()
            } catch {
                //log?.error("Error cleaning up cache: \(error)")
            }
        }

        //if let error = error {
        //    log?.error("Save to disk coordination failed: \(error.localizedDescription)")
        //}
    }

    public func removeValue(for key: URL) {
        guard let containerURL = containerURL else { return }
        let destinationURL = containerURL.appendingPathComponent(key.lastPathComponent)
        var error: NSError?
        NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: destinationURL,
                                                         options: .forDeleting,
                                                         error: &error) { url in
            do {
                try fileManager.removeItem(at: url)
            } catch {
                guard (error as NSError).code != NSFileReadNoSuchFileError else { return }
                //log?.error("Error clearing image: \(error)")
            }
        }

        //if let error = error {
        //    log?.error("Remove \(key) from disk coordination failed: \(error.localizedDescription)")
        //}
    }

    // MARK: - Read

    public func value(for key: URL) -> T? {
        guard let containerURL = containerURL else { return nil }
        let destinationURL = containerURL.appendingPathComponent(key.lastPathComponent)
        var result: T?
        var error: NSError?
        NSFileCoordinator(filePresenter: nil).coordinate(readingItemAt: destinationURL,
                                                         options: .withoutChanges,
                                                         error: &error) { url in
            do {
                let data = try Data(contentsOf: url)
                result = try coder.decode(data)
            } catch let error as NSError {
                guard error.code != NSFileReadNoSuchFileError else { return }
                //log?.error("Error reading data: \(error)")
            } catch {
                //log?.error("Error reading decoding data: \(error)")
            }
        }

        // TODO: ignore NSFileReadNoSuchFileError?
        //if let error = error {
        //    log?.error("Read \(key) from disk coordination failed: \(error.localizedDescription)")
        //}

        return result
    }

    // MARK: - Maintenance

    /// Remove all items from cache.
    public func removeAll() {
        guard let containerURL = containerURL else { return }
        var error: NSError?
        NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: containerURL,
                                                         options: .forDeleting,
                                                         error: &error) { url in
            do {
                // TODO: remove cache directory or just its contents
                try fileManager.removeItem(at: url)
            } catch {
                guard (error as NSError).code != NSFileReadNoSuchFileError else { return }
                //log?.error("Error clearing image: \(error)")
            }
        }

        // TODO: ignore NSFileReadNoSuchFileError?
        //if let error = error {
        //    log?.error("Deleting cache from disk coordination failed: \(error.localizedDescription)")
        //}
    }

    // MARK: - Private

    fileprivate let coordinationQueue: OperationQueue = {
        let coordinationQueue = OperationQueue()
        coordinationQueue.name = "com.mgacy.Adequate.coordinationQueue"
        return coordinationQueue
    }()

    /// Purge oldest items if number of files in cache > maxFileCount
    private func cleanupCache() throws {
        guard let containerURL = containerURL else { return }

        var files: [URL]?
        var error: NSError?
        // swiftlint:disable:next identifier_name
        let fc = NSFileCoordinator()
        fc.coordinate(readingItemAt: containerURL, options: .withoutChanges, error: &error) { url in
            do {
                files = try markFilesForDeletion(at: url, maxFileCount: maxFileCount)
            } catch {
                //log?.error("Error trying to mark files for deletion: \(error)")
            }
        }

        //if let error = error {
        //    log?.error("Reading files for deletion from disk coordination failed: \(error.localizedDescription)")
        //}

        //if let files = try markFilesForDeletion(at: containerURL, maxFileCount: maxFileCount) {
        if let files = files {
            let intents = files.map { NSFileAccessIntent.writingIntent(with: $0, options: .forDeleting) }
            fc.coordinate(with: intents, queue: coordinationQueue) { [weak self] accessorError in
                guard accessorError == nil else {
                    // wiftlint:disable:next line_length
                    //self?.log?.error("Encountered error while awaiting access to delete cached files: \(accessorError!.localizedDescription)")
                    return
                }

                do {
                    for intent in intents {
                        try self?.fileManager.removeItem(at: intent.url)
                    }
                } catch {
                    //self?.log?.error("Error trying to cleanup cache: \(error)")
                }
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
