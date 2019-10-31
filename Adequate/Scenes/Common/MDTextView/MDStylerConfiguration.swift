//
//  MDStylerConfiguration.swift
//  Adequate
//
//  Created by John Nguyen on 10.08.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

public struct MDStylerConfiguration: Equatable {
    public var fonts: MDFontCollection
    public var colors: MDColorCollection
    public var paragraphStyles: MDParagraphStyleCollection
}

public extension MDStylerConfiguration {
    init() {
        fonts = MDFontCollection()
        colors = MDColorCollection.system
        paragraphStyles = MDParagraphStyleCollection()
    }
}
