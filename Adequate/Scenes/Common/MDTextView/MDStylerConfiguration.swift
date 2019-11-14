//
//  MDStylerConfiguration.swift
//  Adequate
//
//  Created by John Nguyen on 10.08.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

import Down

public struct MDStylerConfiguration: Equatable {
    public var fonts: MDFontCollection
    public var colors: MDColorCollection
    public var paragraphStyles: MDParagraphStyleCollection

    public var listItemOptions: ListItemOptions
}

public extension MDStylerConfiguration {
    init() {
        fonts = MDFontCollection()
        colors = MDColorCollection.system
        paragraphStyles = MDParagraphStyleCollection()

        listItemOptions = ListItemOptions(maxPrefixDigits: 0,
                                          spacingAfterPrefix: 7.5874023438,
                                          spacingAbove: 0,
                                          spacingBelow: 8)
    }
}

// MARK: - ListItemOptions + Equatable
extension ListItemOptions: Equatable {
    public static func == (lhs: ListItemOptions, rhs: ListItemOptions) -> Bool {
        return lhs.maxPrefixDigits == rhs.maxPrefixDigits &&
            lhs.spacingAfterPrefix == rhs.spacingAfterPrefix &&
            lhs.spacingAbove == rhs.spacingAbove &&
            lhs.spacingBelow == rhs.spacingBelow
    }
}
