//
//  CurrentDealManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

enum CurrentDealConstants {
    static let groupID = "group.mgacy.com.currentDeal"
    // CurrentDeal - UserDefaults
    //static let x = "currentDealID"
    //static let y = "currentDealTitle"
}

// MARK: - Error

public enum CurrentDealManagerError: Error {
    case file(error: Error)
    case missingDeal
    case missingImage
}

// MARK: - Model

public struct CurrentDeal: Codable {
    let id: String
    let title: String
    //let createdAt: Date
    //let updatedAt: Date
    //let imageName: String
    let imageURL: URL // should this be optional?
    let minPrice: Int
    let maxPrice: Int?
    //let priceComparison: String?
    //let isSoldOut: Bool
}

// MARK: - A

public class CurrentDealManager {

    //private let defaults: UserDefaults
    private let sharedContainerURL: URL

    // MARK: - Lifecycle

    // TODO: init with groupID?
    init(){
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: CurrentDealConstants.groupID)!
        //self.defaults = defaults
        self.sharedContainerURL = url
    }

    // MARK: - A

    public func saveDeal(_ deal: CurrentDeal) {
        print("Saving CurrentDeal: \(deal) ...")

        // TODO: make async
        // Save CurrentDeal
        if let data = try? JSONEncoder().encode(deal) {
            do {
                try data.write(to: sharedContainerURL.appendingPathComponent(.dealLocation))
            } catch {
                print("Error writing data to file")
            }
        }

        // Save Image
        let destinationURL = sharedContainerURL
            .appendingPathComponent(.imageLocation)
            //.appendingPathExtension(deal.imageURL.pathExtension)

        URLSession.shared.downloadTask(with: deal.imageURL) { (fileURL, _, _) in
            guard let fileURL = fileURL else {
                //return completion(nil)
                return
            }

            // Try to delete existing image if it exists
            // ...

            do {
                //print("Deleting item at \(destinationURL)")
                //try FileManager.default.removeItem(at: destinationURL)

                print("Replacing item at \(destinationURL)")
                let _ = try FileManager.default.replaceItemAt(destinationURL, withItemAt: fileURL)

                //print("Moving \(fileURL) to \(destinationURL)")
                //try FileManager.default.moveItem(at: fileURL, to: destinationURL)
                //completion(destinationUrl)
            } catch let error {
                print("ERROR: \(error)")
                //completion(nil)
            }
        }
        .resume()
    }

    // MARK: - B

    public func readDeal() -> CurrentDeal? {
        let dealURL = sharedContainerURL.appendingPathComponent(.dealLocation)
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
        guard let imageData = try? Data(contentsOf: sharedContainerURL.appendingPathComponent(.imageLocation)) else {
            print("Error reading image data")
            return nil
        }
        return UIImage(data: imageData)
    }

}

fileprivate extension String {
    static let dealLocation = "deal.json"
    static let imageLocation = "dealImage"
}
