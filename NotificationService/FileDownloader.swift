//
//  FileDownloader.swift
//  NotificationService
//
//  Created by Mathew Gacy on 10/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

class FileDownloader {

    //private let fileManager: FileManager = .default
    private var fileDirectory: URL {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: path)
    }

    func downloadFile(from url: URL, as fileName: String, completion: @escaping (URL?) -> Void) {
        let destinationUrl = fileDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension(url.pathExtension)

        URLSession.shared.downloadTask(with: url) { (fileUrl, _, _) in
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
