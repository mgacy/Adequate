//
//  FontBook.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

enum FontBook {

    // TODO: rename
    static let largeTitle: UIFont = {
        // LaunchScreen uses sie 34
        let font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        return UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
    }()

    static let mainTitle: UIFont = {
        // SFUIDisplay | weight: Regular | size: 22pt | leading: 28pt | tracking: 16pt
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

    static var regularButton: UIFont = {
        let font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }()

    static var mediumButton: UIFont = {
        let font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .medium)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }()
}
