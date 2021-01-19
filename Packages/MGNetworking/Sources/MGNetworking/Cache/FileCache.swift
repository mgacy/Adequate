//
//  FileCache.swift
//  
//
//  Created by Mathew Gacy on 12/26/20.
//

import Foundation

public final class FileCache<T>: Caching {

    let maxFileCount: Int

    private let fileManager: FileManager

    private let fileLocation: FileLocation

    private let coder: Coder<T>

    private var log: SystemLogger.Type?

    private let coordinationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.mgacy.Adequate.coordinationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private var containerURL: URL? {
        return fileLocation.containerURL
    }

    // MARK: - Lifecycle

    public init(fileLocation: FileLocation, coder: Coder<T>, maxFileCount: Int = 5) {
        self.fileManager = .default
        self.maxFileCount = maxFileCount
        self.fileLocation = fileLocation
        self.coder = coder

        if #available(iOS 14.0, *) {
            SystemLogger.destination = SystemLogger.LogWrapper(subsystem: .main, category: .fileCache)
        } else {
            SystemLogger.destination = SystemLogger.OldWrapper(subsystem: .main, category: .fileCache)
        }
        self.log = SystemLogger.self

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
            log?.error("Error getting data from \(value): \(error)")
            return
        }

        let errorPointer: NSErrorPointer = nil
        NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: destinationURL,
                                                         options: .forReplacing,
                                                         error: errorPointer) { url in
            // Write file
            do {
                // Ensure caches directory exists
                try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true,
                                                attributes: nil)
                try data.write(to: url)
            } catch {
                log?.error("Error writing image: \(error)")
            }

            // Cleanup cache
            do {
                try cleanupCache()
            } catch {
                log?.error("Error cleaning up cache: \(error)")
            }
        }

        if let error = errorPointer?.pointee {
            log?.error("Save to disk coordination failed: \(error.localizedDescription)")
        }
    }

    public func removeValue(for key: URL) {
        guard let containerURL = containerURL else { return }
        let destinationURL = containerURL.appendingPathComponent(key.lastPathComponent)
        let errorPointer: NSErrorPointer = nil
        NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: destinationURL,
                                                         options: .forDeleting,
                                                         error: errorPointer) { url in
            do {
                try fileManager.removeItem(at: url)
            } catch {
                if (error as NSError).code != NSFileNoSuchFileError {
                    log?.error("Error clearing image: \(error)")
                }
            }
        }

        if let error = errorPointer?.pointee {
            log?.error("Remove \(key) from disk coordination failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Read

    public func value(for key: URL) -> T? {
        guard let containerURL = containerURL else { return nil }
        let destinationURL = containerURL.appendingPathComponent(key.lastPathComponent)
        var result: T?
        let errorPointer: NSErrorPointer = nil
        NSFileCoordinator(filePresenter: nil).coordinate(readingItemAt: destinationURL,
                                                         options: .withoutChanges,
                                                         error: errorPointer) { url in
            do {
                let data = try Data(contentsOf: url)
                result = try coder.decode(data)
            } catch let error as NSError {
                if error.code != NSFileReadNoSuchFileError {
                    log?.error("Error reading data: \(error)")
                }
            } catch {
                log?.error("Error reading decoding data: \(error)")
            }
        }

        if let error = errorPointer?.pointee {
            log?.error("Read \(key) from disk coordination failed: \(error.localizedDescription)")
        }
        return result
    }

    // MARK: - Maintenance

    /// Remove all items from cache.
    public func removeAll() {
        guard let containerURL = containerURL else { return }
        let errorPointer: NSErrorPointer = nil
        NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: containerURL,
                                                         options: .forDeleting,
                                                         error: errorPointer) { url in
            do {
                // TODO: remove cache directory or just its contents
                try fileManager.removeItem(at: url)
            } catch {
                if (error as NSError).code != NSFileNoSuchFileError {
                    log?.error("Error clearing image: \(error)")
                }
            }
        }

        if let error = errorPointer?.pointee {
            log?.error("Deleting cache from disk coordination failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Private

    /// Purge oldest items if number of files in cache > maxFileCount
    private func cleanupCache() throws {
        guard let containerURL = containerURL else { return }

        var files: [URL]?
        let errorPointer: NSErrorPointer = nil
        // swiftlint:disable:next identifier_name
        let fc = NSFileCoordinator()
        fc.coordinate(readingItemAt: containerURL, options: .withoutChanges, error: errorPointer) { url in
            do {
                files = try markFilesForDeletion(at: url, maxFileCount: maxFileCount)
            } catch {
                log?.error("Error trying to mark files for deletion: \(error)")
            }
        }

        if let error = errorPointer?.pointee {
            log?.error("Reading files for deletion from disk coordination failed: \(error.localizedDescription)")
        }

        if let files = files {
            let intents = files.map { NSFileAccessIntent.writingIntent(with: $0, options: .forDeleting) }
            fc.coordinate(with: intents, queue: coordinationQueue) { [weak self] accessorError in
                guard accessorError == nil else {
                    // swiftlint:disable:next line_length
                    self?.log?.error("Encountered error while awaiting access to delete cached files: \(accessorError!.localizedDescription)")
                    return
                }

                for intent in intents {
                    do {
                        try self?.fileManager.removeItem(at: intent.url)
                    } catch let error as NSError {
                        if error.code != NSFileNoSuchFileError {
                            self?.log?.error("Error trying to cleanup cache: \(error)")
                        }
                    } catch {
                        self?.log?.error("Error trying to cleanup cache: \(error)")
                    }
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
