//
//  DealEntry.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

#if canImport(WidgetKit)
import UIKit
import WidgetKit

public struct DealEntry: TimelineEntry {
    public var date: Date = Date()
    public let deal: CurrentDeal // Specify a protocol instead?
    public let image: UIImage
}

// MARK: - DealEntry+placeholder
extension DealEntry {
    static var placeholder: DealEntry {
        return DealEntry(deal: .placeholder, image: .placeholder)
    }
}

// MARK: - CurrentDeal+placeholder
extension CurrentDeal {
    static var placeholder: CurrentDeal {
        let imageURL = URL(string: "https://via.placeholder.com/600/d32776")!
        return CurrentDeal(id: "fake_id", title: L10n.widgetExtensionPlaceholderTitle, imageURL: imageURL,
                           minPrice: 10.99, maxPrice: 19.99, launchStatus: .launch)
    }
}

// MARK: - UIImage+placeholder
extension UIImage {
    static var placeholder: UIImage {
        return #imageLiteral(resourceName: "PlaceholderDealImage")
    }
}

// MARK: - UIColor+image
extension UIColor {

    // https://stackoverflow.com/a/48441178/4472195
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
#endif
