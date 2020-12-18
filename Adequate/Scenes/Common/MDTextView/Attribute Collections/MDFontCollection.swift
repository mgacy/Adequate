//
//  MDFontCollection.swift
//  Adequate
//
//  Created by John Nguyen on 22.06.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

import UIKit
import Down

// TODO: Documentation -> When using dynamic fonts, we should make sure the text view property
// `adjustsFontForContentSizeCategory` is actually false. Instead override `traitCollectionDidChange()` to
// manually reload the content.

public struct MDFontCollection: Equatable, FontCollection {
    public var heading1: UIFont
    public var heading2: UIFont
    public var heading3: UIFont
    public var heading4: UIFont
    public var heading5: UIFont
    public var heading6: UIFont
    public var body: UIFont
    public var code: UIFont
    public var listItemPrefix: UIFont
}

// MARK: - Initializers
public extension MDFontCollection {
    // TODO: move this into static var?
    init() {
        heading1 = .preferredFont(for: .title3, adding: .traitBold)
        heading2 = .preferredFont(forTextStyle: .headline) // .title2?
        heading3 = .preferredFont(for: .body, adding: .traitBold) // .title3?
        heading4 = .boldSystemFont(ofSize: 20) // ?
        heading5 = .boldSystemFont(ofSize: 20) // ?
        heading6 = .boldSystemFont(ofSize: 20) // ?

        // body
        body = .preferredFont(forTextStyle: .body)

        // code
        code = .monospacedSystemFont(ofSize: 17.0, weight: .regular)

        // listItemPrefix
        let listFont = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        listItemPrefix = UIFontMetrics.default.scaledFont(for: listFont)
    }

    // TODO: add initializer accepting `FontBook`?
}
