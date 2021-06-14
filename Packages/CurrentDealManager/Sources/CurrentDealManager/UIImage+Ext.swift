//
//  UIImage+Ext.swift
//
//
//  Created by Mathew Gacy on 1/5/21.
//

import UIKit

// MARK: - UIImage+scaled
/// See comparison of different methods at: https://nshipster.com/image-resizing/
extension UIImage {

    // https://stackoverflow.com/a/54380286/4472195
    func scaled(to maxSize: CGFloat) -> UIImage? {
        let newSize = size.scaled(to: maxSize)

        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false // enable transparency
        let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
        return renderer.image { _ in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }

    func scaledPngData(to maxSize: CGFloat) -> Data? {
        let newSize = size.scaled(to: maxSize)

        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false // enable transparency
        let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
        return renderer.pngData { _ in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}

extension CGSize {

    func scaled(to maxSize: CGFloat) -> CGSize {
        let aspectRatio: CGFloat = min(maxSize / width, maxSize / height)
        return CGSize(width: width * aspectRatio, height: height * aspectRatio)
    }
}
