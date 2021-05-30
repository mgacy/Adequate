//
//  CurrentDealManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Combine

public enum CurrentDealManagerError: Error {
    case file(error: Error)
    case network(error: Error)
    case encoding(EncodingError)
    case decoding(DecodingError)
    case invalidData // wouldn't this be .decoding?
    //case missingFile(URL)
    case missingDeal
    case missingImage
    case unknown(Error)

    public static func wrap(_ error: Error) -> Self { // `transform(_:)`?
        // swiftlint:disable force_cast
        switch error {
        case is CurrentDealManagerError:
            return error as! CurrentDealManagerError
        case is EncodingError:
            return .encoding(error as! EncodingError)
        case is DecodingError:
            return .decoding(error as! DecodingError)
        case is URLError:
            return .network(error: error)
        // swiftlint:enable force_cast
        default:
            switch (error as NSError).code {
            case NSFileNoSuchFileError, NSFileReadNoSuchFileError:
                return .file(error: error)
            default:
                return .unknown(error)
            }
        }
    }
}

public protocol CurrentDealManaging {
    func save(currentDeal: CurrentDeal) -> AnyPublisher<Void, CurrentDealManagerError>
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

    public func save(currentDeal: CurrentDeal) -> AnyPublisher<Void, CurrentDealManagerError> {
        return Publishers.Zip(
            saveCurrentDeal(currentDeal),
            saveImage(currentDeal)
        )
        .map { _ in return }
        .eraseToAnyPublisher()
    }

    private func saveCurrentDeal(_ deal: CurrentDeal) -> AnyPublisher<Void, CurrentDealManagerError> {
        //return Deferred {
        return Future<Void, CurrentDealManagerError> { promise in
            DispatchQueue.global().async {
                do {
                    let data = try JSONEncoder().encode(deal)
                    try data.write(to: self.sharedContainerURL.appendingPathComponent(Constants.dealLocation))
                    promise(.success(()))
                } catch {
                    promise(.failure(CurrentDealManagerError.wrap(error)))
                }
            }
        }
        //}
        .eraseToAnyPublisher()
    }

    private func saveImage(_ deal: CurrentDeal) -> AnyPublisher<Void, CurrentDealManagerError> {
        // TODO: first try to load image from FileCache in case Notification service successfully downloaded it
        session.dataTaskPublisher(for: deal.imageURL)
            .map(\.data)
            .tryMap { try self.scalePng(data: $0) }
            .tryMap { try self.saveImageData($0) }
            .mapError { CurrentDealManagerError.wrap($0) }
            .eraseToAnyPublisher()
    }

    private func scalePng(data: Data) throws -> Data {
        guard let scaledData = UIImage(data: data)?.scaledPngData(to: Constants.maxImageSize) else {
            throw CurrentDealManagerError.invalidData
        }
        return scaledData
    }

    private func saveImageData(_ data: Data) throws {
        let fileURL = sharedContainerURL.appendingPathComponent(Constants.imageLocation)
        // Check if file exists and remove it if so.
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(atPath: fileURL.path)
        }

        try data.write(to: fileURL)
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
