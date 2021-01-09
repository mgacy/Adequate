//
//  TestUtils.swift
//
//
//  Created by Mathew Gacy on 1/6/21.
//

import UIKit
import CurrentDealManager

// swiftlint:disable line_length

// MARK: - UIColor+Helper
public extension UIColor {

    func pngData(_ size: CGSize = CGSize(width: 1, height: 1)) -> Data {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.pngData { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
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

// Via John Sundell: https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        guard let url = URL(string: "\(value)") else {
            preconditionFailure("Invalid static URL string: \(value)")
        }
        self = url
    }
}

// MARK: - CurrentDeal

extension URL {
    static let gif: URL = "https://d2b8wt72ktn9a2.cloudfront.net/mediocre/image/upload/c_pad,f_auto,h_600,q_auto,w_600/psi6hyuuwmmj6oopqoiv.gif"
    static let deal: URL = "https://d2b8wt72ktn9a2.cloudfront.net/mediocre/image/upload/c_pad,f_auto,h_600,q_auto,w_600/j1cdevi8xm7iglxyy8qm.png"
    static let anotherDeal: URL = "https://d2b8wt72ktn9a2.cloudfront.net/mediocre/image/upload/c_pad,f_auto,h_600,q_auto,w_600/bgkysfggkhtg35wyam2c.png"
}

extension CurrentDeal {

    static var testDeal: CurrentDeal {
        return CurrentDeal(id: "a6k5A000000cWOLQA2",
                           title: "Pick-Your-2-Pack 500 or 1000 Piece Jigsaw Puzzles",
                           imageURL: .deal,
                           minPrice: 9,
                           maxPrice: 19.99,
                           launchStatus: .launch)
    }
}
