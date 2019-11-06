//
//  MDUnorderedListItemParagraphStyler.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/2/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Down

/// Paragraph styler for unordered list items.
public class MDUnorderedListItemParagraphStyler {

    public var indentation: CGFloat {
        return bulletPrefixWidth + options.spacingAfterPrefix
    }

    /// The paragraph style intended for all paragraphs excluding the first.
    public var trailingParagraphStyle: NSParagraphStyle {
        let contentIndentation = indentation
        let style = baseStyle
        style.firstLineHeadIndent = contentIndentation
        style.headIndent = contentIndentation
        return style
    }

    private let options: ListItemOptions
    private let bulletPrefixWidth: CGFloat

    private var baseStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacingBefore = options.spacingAbove
        style.paragraphSpacing = options.spacingBelow
        return style
    }

    public init(options: ListItemOptions, prefixFont: DownFont) {
        self.options = options
        self.bulletPrefixWidth = prefixFont.widthOfBullet
    }


    /// The paragraph style intended for the first paragraph of the list item.
    ///
    /// - Parameter prefixWidth: the width (in points) of the list item prefix.
    public func leadingParagraphStyle(prefixWidth: CGFloat) -> NSParagraphStyle {
        let contentIndentation = indentation

        //let prefixIndentation: CGFloat = contentIndentation - options.spacingAfterPrefix - prefixWidth
        let prefixIndentation: CGFloat = 0.0

        //let prefixSpill = max(0, prefixWidth - bulletPrefixWidth)
        //let firstLineContentIndentation = contentIndentation + prefixSpill
        let firstLineContentIndentation = contentIndentation

        let style = baseStyle

        // The indentation of the first line of the receiver.
        style.firstLineHeadIndent = prefixIndentation

        style.tabStops = [tabStop(at: firstLineContentIndentation)]

        // The indentation of the receiver’s lines other than the first.
        style.headIndent = contentIndentation

        return style
    }

    private func tabStop(at location: CGFloat) -> NSTextTab {
        return NSTextTab(textAlignment: .left, location: location, options: [:])
    }
}

// MARK: - Helpers

private extension UIFont {

    var widthOfBullet: CGFloat {
        return NSAttributedString(string: "•", attributes: [.font: self])
            .size()
            .width
    }
}
