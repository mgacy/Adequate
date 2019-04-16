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

extension CurrentDeal: Equatable {}

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

    deinit { print("\(#function) - CurrentDealManager") }

    // MARK: - Write

    public func saveDeal(_ deal: CurrentDeal) {
        // Save CurrentDeal
        DispatchQueue.global().async {
            if let data = try? JSONEncoder().encode(deal) {
                do {
                    try data.write(to: self.sharedContainerURL.appendingPathComponent(.dealLocation))
                } catch {
                    print("Error writing data to file")
                }
            }
        }

        // Save Image
        let destinationURL = sharedContainerURL
            .appendingPathComponent(.imageLocation)
        URLSession.shared.downloadTask(with: deal.imageURL) { (fileURL, _, _) in
            guard let fileURL = fileURL else {
                return
            }

            do {
                if let localImageURL = try FileManager.default.replaceItemAt(destinationURL, withItemAt: fileURL) {
                    self.saveScaledImage(from: localImageURL)
                }

            } catch let error {
                print("ERROR: \(error)")
            }
        }
        .resume()
    }

    private func saveScaledImage(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            guard let originalImage = UIImage(data: data) else {
                print("Error downloading image")
                throw CurrentDealManagerError.missingImage
            }

            guard let scaledImage = originalImage.scaled(to: 150.0) else {
                print("Error rescaling image")
                throw CurrentDealManagerError.missingImage
            }
            self.saveImage(image: scaledImage)
        } catch let error {
            print("ERROR: \(error)")
        }
    }

    // https://stackoverflow.com/a/53894441/4472195
    private func saveImage(image: UIImage) {
        let fileURL = sharedContainerURL.appendingPathComponent(.imageLocation)
        guard let data = image.pngData() else {
            print("Error getting pngData from image")
            return
        }

        // Check if file exists and remove it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
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

// MARK: - String Constants
fileprivate extension String {
    static let dealLocation = "deal.json"
    static let imageLocation = "dealImage"
}

// MARK: - UIImage+scaled
fileprivate extension UIImage {
    // https://stackoverflow.com/a/54380286/4472195
    func scaled(to maxSize: CGFloat) -> UIImage? {
        let aspectRatio: CGFloat = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)

        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false // enable transparency
        let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}
