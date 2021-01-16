//
//  UIImage+Ext.swift
//
//
//  Created by Mathew Gacy on 1/5/21.
//

import UIKit

// MARK: - UIImage+scaled
extension UIImage {

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

    func scaledPngData(to maxSize: CGFloat) -> Data? {
        let aspectRatio: CGFloat = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)

        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false // enable transparency
        let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
        return renderer.pngData { _ in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}
