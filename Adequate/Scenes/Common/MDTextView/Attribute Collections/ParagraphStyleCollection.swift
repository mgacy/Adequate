//
//  ParagraphStyleCollection.swift
//  Down
//
//  Created by John Nguyen on 27.07.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

import UIKit

// TODO: rename `MDParagraphStyleCollection`
public struct ParagraphStyleCollection: Equatable {
    public let heading1: NSParagraphStyle
    public let heading2: NSParagraphStyle
    public let heading3: NSParagraphStyle
    //public let heading4: NSParagraphStyle
    //public let heading5: NSParagraphStyle
    //public let heading6: NSParagraphStyle
    public let body: NSParagraphStyle
    public let code: NSParagraphStyle
    public let list: NSParagraphStyle
}

// MARK: - Initializers
public extension ParagraphStyleCollection {
    // TODO: move this into static var?
    init() {
        let headingStyle = NSMutableParagraphStyle()
        headingStyle.paragraphSpacing = 8

        let bodyStyle = NSMutableParagraphStyle()
        bodyStyle.paragraphSpacingBefore = 8
        bodyStyle.paragraphSpacing = 8
        bodyStyle.lineSpacing = 8

        let codeStyle = NSMutableParagraphStyle()
        codeStyle.paragraphSpacingBefore = 8
        codeStyle.paragraphSpacing = 8

        // List
        // TODO: obtain value from attributes of font?
        let indent: CGFloat = 15.0
        let pGraphSpacing: CGFloat = 8.0
        let listStyle = NSMutableParagraphStyle()
        //let listStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle

        // The indentation of the first line of the receiver.
        listStyle.firstLineHeadIndent = 0.0

        // The indentation of the receiver’s lines other than the first.
        listStyle.headIndent = indent

        listStyle.tabStops = [NSTextTab(textAlignment: .left, location: 1, options: [:])]
        listStyle.defaultTabInterval = indent

        // The trailing indentation of the receiver.
        //listStyle.tailIndent = 0.0

        // The mode that should be used to break lines in the receiver.
        //listStyle.lineBreakMode: NSLineBreakMode

        // The receiver’s maximum line height.
        //listStyle.maximumLineHeight = 0.0

        // The receiver’s minimum height.
        //listStyle.minimumLineHeight = 0.0

        // The distance in points between the bottom of one line fragment and the top of the next.
        //listStyle.lineSpacing = 0.0

        // The space after the end of the paragraph.
        listStyle.paragraphSpacing = pGraphSpacing

        // The distance between the paragraph’s top and the beginning of its text content.
        //listStyle.paragraphSpacingBefore = pGraphSpacing
        listStyle.paragraphSpacingBefore = 0.0

        // The line height multiple.
        //listStyle.lineHeightMultiple = 0.0

        // Set properties
        heading1 = headingStyle
        heading2 = headingStyle
        heading3 = headingStyle
        //body = bodyStyle
        body = ParagraphStyleCollection.makeBaseStyle(headIndent: 0.0)
        code = codeStyle
        list = listStyle
        //list = ParagraphStyleCollection.makeBaseStyle(headIndent: 15.0)
    }
}

// MARK: - Factory
private extension ParagraphStyleCollection {
    static func makeBaseStyle(headIndent: CGFloat) -> NSMutableParagraphStyle {
        // TODO: obtain value from attributes of font?
        let indent: CGFloat = 15.0
        let pGraphSpacing: CGFloat = 8.0

        let paragraphStyle = NSMutableParagraphStyle()

        /// The indentation of the first line of the receiver.
        paragraphStyle.firstLineHeadIndent = 0.0

        /// The indentation of the receiver’s lines other than the first.
        paragraphStyle.headIndent = headIndent

        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 1, options: [:])]
        paragraphStyle.defaultTabInterval = indent

        /// The trailing indentation of the receiver.
        //paragraphStyle.tailIndent = 0.0

        /// The mode that should be used to break lines in the receiver.
        //paragraphStyle.lineBreakMode: NSLineBreakMode

        /// The receiver’s maximum line height.
        //paragraphStyle.maximumLineHeight = 0.0

        /// The receiver’s minimum height.
        //paragraphStyle.minimumLineHeight = 0.0

        /// The distance in points between the bottom of one line fragment and the top of the next.
        //paragraphStyle.lineSpacing = 0.0

        /// The space after the end of the paragraph.
        paragraphStyle.paragraphSpacing = pGraphSpacing

        /// The distance between the paragraph’s top and the beginning of its text content.
        //paragraphStyle.paragraphSpacingBefore = pGraphSpacing
        paragraphStyle.paragraphSpacingBefore = 0.0

        /// The base writing direction for the receiver.
        //paragraphStyle.baseWritingDirection: NSWritingDirection

        /// The line height multiple.
        //paragraphStyle.lineHeightMultiple = 0.0

        return paragraphStyle
    }
}
