//
//  CurrentDealManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public enum CurrentDealManagerError: Error {
    case file(error: Error) // Type as NSError?
    //case encoding?
    //case decoding?
    //case invalidData - wouldnt this be .decoding?
    case missingDeal
    case missingImage
}

public protocol CurrentDealManaging {
    func saveDeal(_ deal: CurrentDeal)
    func readDeal() -> CurrentDeal?
    func readImage() -> UIImage?
}

public class CurrentDealManager: CurrentDealManaging {

    private let fileManager: FileManager

    private let sharedContainerURL: URL

    private let session: URLSession

    // MARK: - Lifecycle

    public init(session: URLSession = .shared) {
        let fileManager = FileManager.default
        let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Constants.groupID)!
        self.session = session
        self.sharedContainerURL = url
        self.fileManager = fileManager
    }

    //deinit { print("\(#function) - CurrentDealManager") }

    // MARK: - Write

    public func saveDeal(_ deal: CurrentDeal) {
        // Save CurrentDeal
        DispatchQueue.global().async {
            if let data = try? JSONEncoder().encode(deal) {
                do {
                    try data.write(to: self.sharedContainerURL.appendingPathComponent(Constants.dealLocation))
                } catch {
                    // FIXME: improve handling
                    print("Error writing data to file")
                }
            }
        }

        // Save Image
        // TODO: first try to load image from FileCache in case Notification service successfully downloaded it
        session.dataTask(with: deal.imageURL) { data, _, _ in
            guard let data = data, let image = UIImage(data: data)?.scaled(to: Constants.maxImageSize) else { return }
            self.saveImage(image: image)
        }
        .resume()
    }

    private func saveImage(image: UIImage) {
        let fileURL = sharedContainerURL.appendingPathComponent(Constants.imageLocation)
        guard let data = image.pngData() else {
            print("Error getting pngData from image")
            return
        }

        // Check if file exists and remove it if so.
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("Error removing image file:", removeError)
            }
        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("Error saving file:", error)
        }
    }

    // MARK: - Read

    public func readDeal() -> CurrentDeal? {
        let dealURL = sharedContainerURL.appendingPathComponent(Constants.dealLocation)
        do {
            let data = try Data(contentsOf: dealURL)
            let currentDeal = try JSONDecoder().decode(CurrentDeal.self, from: data)
            return currentDeal
        } catch {
            print("Error reading CurrentDeal data: \(error)")
            return nil
        }
    }

    public func readImage() -> UIImage? {
        let imageURL = sharedContainerURL.appendingPathComponent(Constants.imageLocation)
        do {
            let imageData = try Data(contentsOf: imageURL)
            return UIImage(data: imageData)
        } catch {
            print("Error reading image data")
            return nil
        }
    }
}

// MARK: - Types
extension CurrentDealManager {

    public enum Constants {
        static let groupID = "group.mgacy.com.currentDeal"
        static let maxImageSize: CGFloat = 150
        // Filenames
        static let dealLocation = "deal.json"
        static let imageLocation = "dealImage"
    }
}
