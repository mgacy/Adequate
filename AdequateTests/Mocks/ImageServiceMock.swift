//
//  ImageServiceMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise
@testable import Adequate

class ImageServiceMock: ImageServiceType {

    var hasCachedImage: Bool = false

    var response: Result<UIImage, NetworkClientError> = .failure(NetworkClientError.imageDecodingFailed)

    var responseDelay: TimeInterval?

    var imageColor: UIColor = .blue
    var imageSize: CGSize = CGSize(width: 600.0, height: 600.0)

    init() {
        setDefaultImage()
    }

    // MARK: - ImageServiceType

    func fetchImage(for url: URL) -> Promise<UIImage> {
        if let delay = responseDelay {
            return Promise<UIImage> { fulfill, reject in
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    switch self.response {
                    case .success(let image):
                        fulfill(image)
                    case .failure(let error):
                        reject(error)
                    }
                }
            }
        } else {
            switch response {
            case .success(let image):
                return Promise(value: image)
            case .failure(let error):
                return Promise(error: error)
            }
        }
    }

    func fetchedImage(for url: URL, tryingSecondary: Bool) -> UIImage? {
        guard hasCachedImage, case .success(let image) = response else {
            return nil
        }
        return image
    }

    func clearCache() {
        hasCachedImage = false
    }

    // MARK: - Helpers

    func setDefaultImage() {
        response = .success(makeImage(color: imageColor, size: imageSize))
    }

    func setDefaultError() {
        response = .failure(.imageDecodingFailed)
    }

    func makeImage(color: UIColor, size: CGSize) -> UIImage {
        // https://stackoverflow.com/a/48441178/4472195
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
