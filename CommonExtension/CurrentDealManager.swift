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

// MARK: - A

public class CurrentDealManager {

    //private let defaults: UserDefaults
    private let sharedContainerURL: URL
    private let session: URLSession = URLSession.shared

    // MARK: - Lifecycle

    // TODO: init with groupID?
    init() {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: CurrentDealConstants.groupID)!
        //self.defaults = defaults
        //self.session = Self.makeSession()
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
                    // FIXME: improve handling
                    print("Error writing data to file")
                }
            }
        }

        // Save Image
        let destinationURL = sharedContainerURL
            .appendingPathComponent(.imageLocation)
        session.downloadTask(with: deal.imageURL) { (fileURL, _, _) in
            guard let fileURL = fileURL else {
                return
            }

            do {
                if let localImageURL = try FileManager.default.replaceItemAt(destinationURL, withItemAt: fileURL) {
                    self.saveScaledImage(from: localImageURL)
                }

            } catch let error {
                // FIXME: improve handling
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
            // FIXME: improve handling
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

    // MARK: - Alt
    /*
    private func scaleImage(from url: URL, toSize scaledSize: CGFloat = 150.0) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            guard let originalImage = UIImage(data: data) else {
                print("Error downloading image")
                throw CurrentDealManagerError.missingImage
            }

            guard let scaledImage = originalImage.scaled(to: scaledSize) else {
                print("Error rescaling image")
                throw CurrentDealManagerError.missingImage
            }
            return scaledImage
        } catch let error {
            print("ERROR: \(error)")
            return nil
        }
    }
    */
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

    // MARK: Configuration
    /*
    private static func makeSession() -> URLSession {
        //let configuration = URLSessionConfiguration.background(withIdentifier: .sessionConfigID)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20  // seconds
        configuration.timeoutIntervalForResource = 20 // seconds
        configuration.waitsForConnectivity = true     // reachability

        return URLSession(configuration: configuration)
    }
    */
}

// MARK: - String Constants
fileprivate extension String {
    // Filenames
    static let dealLocation = "deal.json"
    static let imageLocation = "dealImage"
    //static let scaledImageLocation = "scaledDealImage"
    // URLSessionConfiguration
    //static let sessionConfigID = "com.mgacy.adequate.current-deal-manager"
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
        return renderer.image { _ in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}
