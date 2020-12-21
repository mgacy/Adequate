//
//  UIFont+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public extension UIFont {

    static func preferredFont(for style: TextStyle, adding symbolicTrait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)

        guard !descriptor.symbolicTraits.contains(symbolicTrait) else {
            return preferredFont(forTextStyle: style)
        }

        let modifiedDescriptor = descriptor.withSymbolicTraits(symbolicTrait) ?? descriptor
        return UIFont(descriptor: modifiedDescriptor, size: descriptor.pointSize)
    }

    // https://mackarous.com/dev/2018/12/4/dynamic-type-at-any-font-weight
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
