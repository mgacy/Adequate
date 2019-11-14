//
//  FontBook.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

struct FontBook {

    static let mainTitle: UIFont = {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2)
        let boldDescriptor = descriptor.withSymbolicTraits(.traitBold)
        return UIFont(descriptor: boldDescriptor!, size: descriptor.pointSize)
    }()

    static var expandedFooter: UIFont = {
        let font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        return UIFontMetrics(forTextStyle: .title2).scaledFont(for: font)
    }()

    static var compactFooter: UIFont = {
        let font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        return UIFontMetrics(forTextStyle: .title3).scaledFont(for: font)
    }()

    static var boldButton: UIFont = {
        let font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .medium)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }()
}
