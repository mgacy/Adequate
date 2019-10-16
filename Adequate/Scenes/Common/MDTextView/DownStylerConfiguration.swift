//
//  DownStylerConfiguration.swift
//  Down
//
//  Created by John Nguyen on 10.08.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

public struct DownStylerConfiguration {
    public var fonts: FontCollection
    public var colors: ColorCollection
    public var paragraphStyles: ParagraphStyleCollection
}

public extension DownStylerConfiguration {
    init() {
        fonts = FontCollection()
        colors = ColorCollection.system
        paragraphStyles = ParagraphStyleCollection()
    }
}
