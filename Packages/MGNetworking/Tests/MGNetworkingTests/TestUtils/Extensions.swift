//
//  File.swift
//  
//
//  Created by Mathew Gacy on 1/1/21.
//

import UIKit

// swiftlint:disable identifier_name

// MARK: - Optional+Helper
public extension Optional {

    struct NilError: Error { }

    // https://github.com/khanlou/Promise
    func unwrap() throws -> Wrapped {
        guard let result = self else {
            throw NilError()
        }
        return result
    }
}

// MARK: - UIColor+Helper
public extension UIColor {

    convenience init(i: Int) {
        self.init(red: UIColor.clampingPercentage(i),
                  green: UIColor.clampingPercentage(i),
                  blue: UIColor.clampingPercentage(i),
                  alpha: 1.0)
    }

    fileprivate static func clampingPercentage(_ value: Int) -> CGFloat {
        if value <= 0 {
            return 0.0
        } else if value >= 255 {
            return 1.0
        } else {
            return CGFloat(value) / 255.0
        }
    }

    // https://stackoverflow.com/a/48441178/4472195
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
