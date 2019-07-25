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

    func downloadFile(from url: URL, as fileName: String, completion: @escaping (URL?) -> Void) {
        // TODO: let destinationUrl = containerURL.appendingPathComponent(url.lastPathComponent)?
        let destinationUrl = containerURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(url.pathExtension)

        session.downloadTask(with: url) { (fileUrl, _, _) in
            guard let fileUrl = fileUrl else {
                return completion(nil)
            }

            do {
                try FileManager.default.moveItem(at: fileUrl, to: destinationUrl)
                completion(destinationUrl)
            } catch let error {
                print("ERROR: \(error)")
                completion(nil)
            }
        }
        .resume()
    }
}
