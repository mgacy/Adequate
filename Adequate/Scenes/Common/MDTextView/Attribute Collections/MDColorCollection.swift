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
    public var heading4: UIColor
    public var heading5: UIColor
    public var heading6: UIColor
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
        heading4 = theme.label
        heading5 = theme.label
        heading6 = theme.label
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

    static var system: MDColorCollection {
        return MDColorCollection(heading1: .label,
                                 heading2: .label,
                                 heading3: .label,
                                 heading4: .label,
                                 heading5: .label,
                                 heading6: .label,
                                 body: .label,
                                 code: .label,
                                 link: .link,
                                 quote: .secondaryLabel,
                                 quoteStripe: .secondaryLabel,
                                 thematicBreak: .secondarySystemBackground, // ?
                                 listItemPrefix: .label,
                                 codeBlockBackground: .secondarySystemBackground) // ?
    }
}
