//
//  FileDownloader.swift
//  NotificationService
//
//  Created by Mathew Gacy on 10/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

class FileDownloader {

    private let session: URLSession = .shared
    private let containerURL: URL

    init(appGroupID: AppGroupID){
        let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID.rawValue)!
        self.containerURL = appGroupURL //.appendingPathComponent("images", isDirectory: true)
    }

    typealias ResultHandler = (Result<URL, FileDownloadError>) -> Void

    func downloadFile(from url: URL, completion: @escaping ResultHandler) {
        let destinationUrl = containerURL
            .appendingPathComponent(url.lastPathComponent)

        session.downloadTask(with: url) { (fileUrl, _, error) in
            if let error = error {
                completion(.failure(.network(error)))
            }

            guard let fileUrl = fileUrl else {
                completion(.failure(.missingFile))
                return
            }

            do {
                // Unlike `FileManager.default.moveItem(at:to:)`, this doesn't throw if file already exists
                guard let url = try FileManager.default.replaceItemAt(destinationUrl, withItemAt: fileUrl) else {
                    throw FileDownloadError.missingFile
                }
                completion(.success(url))
            } catch let error {
                completion(.failure(.file(error)))
            }
        }
        .resume()
    }
}

// MARK: - Support Types
extension FileDownloader {

    enum FileDownloadError: Error {
        case network(Error)
        case file(Error) // `(Error, URLResponse?)`?
        case missingFile
    }
}
