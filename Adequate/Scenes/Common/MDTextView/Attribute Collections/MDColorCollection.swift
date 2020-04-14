//
//  MDColorCollection.swift
//  Adequate
//
//  Created by John Nguyen on 27.07.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

import UIKit
import Down

public struct MDColorCollection: Equatable, ColorCollection {
    public var heading1: UIColor
    public var heading2: UIColor
    public var heading3: UIColor
    //public var heading4: UIColor
    //public var heading5: UIColor
    //public var heading6: UIColor
    public var body: UIColor
    public var code: UIColor
    public var link: UIColor
    public var quote: UIColor
    public var quoteStripe: UIColor
    public var thematicBreak: UIColor
    public var listItemPrefix: UIColor
    public var codeBlockBackground: UIColor
}

// MARK: - Initializers
extension MDColorCollection {

    init(theme: ColorTheme) {
        heading1 = theme.label
        heading2 = theme.label
        heading3 = theme.label
        body = theme.label
        code = theme.label
        link = theme.link
        quote = theme.secondaryLabel
        quoteStripe = theme.secondaryLabel
        thematicBreak = theme.secondarySystemBackground
        listItemPrefix = theme.label
        codeBlockBackground = theme.secondarySystemBackground
    }
}

// MARK: - Default
extension MDColorCollection {

    static var light: MDColorCollection {
        // TODO: update values to match .systemTheme when UIUserInterfaceStyle == .light
        return MDColorCollection(heading1: .black,
                               heading2: .black,
                               heading3: .black,
                               body: .black,
                               code: .black,
                               link: .systemBlue,
                               quote: .darkGray,
                               quoteStripe: .darkGray,
                               thematicBreak: UIColor(white: 0.9, alpha: 1),
                               listItemPrefix: .black,
                               codeBlockBackground: UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1))
    }

    static var dark: MDColorCollection {
        return MDColorCollection(heading1: .white,
                               heading2: .white,
                               heading3: .white,
                               body: .white,
                               code: .white,
                               link: .systemBlue,
                               quote: .darkGray,
                               quoteStripe: .darkGray,
                               thematicBreak: UIColor(white: 0.9, alpha: 1),
                               listItemPrefix: .white,
                               codeBlockBackground: UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1))
    }

    static var system: MDColorCollection {
        return MDColorCollection(heading1: ColorCompatibility.label,
                               heading2: ColorCompatibility.label,
                               heading3: ColorCompatibility.label,
                               body: ColorCompatibility.label,
                               code: ColorCompatibility.label,
                               link: ColorCompatibility.link,
                               quote: ColorCompatibility.secondaryLabel,
                               quoteStripe: ColorCompatibility.secondaryLabel,
                               thematicBreak: ColorCompatibility.secondarySystemBackground, // ?
                               listItemPrefix: ColorCompatibility.label,
                               codeBlockBackground: ColorCompatibility.secondarySystemBackground) // ?
    }
}