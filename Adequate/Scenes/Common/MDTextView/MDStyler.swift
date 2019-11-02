//
//  MDStyler.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/15/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Down

class MDStyler: Styler {

    public var colors: MDColorCollection
    public let fonts: MDFontCollection
    public let paragraphStyles: MDParagraphStyleCollection

    // TODO: observe ThemeManager?
    //var theme: AppTheme

    var listPrefixAttributes: [NSAttributedString.Key : Any] {[
        .font: fonts.listItemPrefix,
        .foregroundColor: colors.listItemPrefix]
    }

    // MARK: - Init

    public init(configuration: MDStylerConfiguration = MDStylerConfiguration()) {
        fonts = configuration.fonts
        colors = configuration.colors
        paragraphStyles = configuration.paragraphStyles
    }

    // MARK: Styler

    func style(document str: NSMutableAttributedString) {}

    func style(blockQuote str: NSMutableAttributedString, nestDepth: Int) {
        // ...
        str.addAttributes([.paragraphStyle: paragraphStyles.body])
    }

    func style(list str: NSMutableAttributedString, nestDepth: Int) {
        // NOTE: DownStyler applies paragraph styling in `style(item:)`
        str.addAttributes([.paragraphStyle: paragraphStyles.list])
    }

    func style(listItemPrefix str: NSMutableAttributedString) {
        str.setAttributes(listPrefixAttributes)
    }

    func style(item str: NSMutableAttributedString, prefixLength: Int) {
        // NOTE: this is where DownStyler applies paragraph styling, rather than style(list:)
    }

    func style(codeBlock str: NSMutableAttributedString, fenceInfo: String?) {
        styleGenericCodeBlock(in: str)
    }

    func style(htmlBlock str: NSMutableAttributedString) {
        styleGenericCodeBlock(in: str)
    }

    func style(customBlock str: NSMutableAttributedString) {}

    func style(paragraph str: NSMutableAttributedString) {
        str.addAttribute(for: .paragraphStyle, value: paragraphStyles.body)
    }

    func style(heading str: NSMutableAttributedString, level: Int) {
        let (font, color, paragraphStyle) = headingAttributes(for: level)

        str.updateExistingAttributes(for: .font) { (currentFont: UIFont) in
            var newFont = font

            if (currentFont.isMonospace) {
                newFont = newFont.monospace
            }

            if (currentFont.isItalic) {
                newFont = newFont.italic
            }

            if (currentFont.isBold) {
                newFont = newFont.bold
            }

            return newFont
        }

        str.addAttributes([
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle])
    }

    func style(thematicBreak str: NSMutableAttributedString) {}

    func style(text str: NSMutableAttributedString) {
        str.setAttributes([
            .font: fonts.body,
            .foregroundColor: colors.body])
    }

    func style(softBreak str: NSMutableAttributedString) {}

    func style(lineBreak str: NSMutableAttributedString) {}

    func style(code str: NSMutableAttributedString) {
        styleGenericInlineCode(in: str)
    }

    func style(htmlInline str: NSMutableAttributedString) {
        styleGenericInlineCode(in: str)
    }

    func style(customInline str: NSMutableAttributedString) {}

    func style(emphasis str: NSMutableAttributedString) {
        str.updateExistingAttributes(for: .font) { (font: UIFont) in
            font.italic
        }
    }

    func style(strong str: NSMutableAttributedString) {
        str.updateExistingAttributes(for: .font) { (font: UIFont) in
            font.bold
        }
    }

    func style(link str: NSMutableAttributedString, title: String?, url: String?) {
        guard let url = url else {
            return
        }
        styleGenericLink(in: str, url: url)
    }

    func style(image str: NSMutableAttributedString, title: String?, url: String?) {
        guard let url = url else {
            return
        }
        styleGenericLink(in: str, url: url)
    }
}

// MARK: - Common Styling
extension MDStyler {

    private func styleGenericCodeBlock(in str: NSMutableAttributedString) {
        // ...
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code
            //.paragraphStyle: adjustedParagraphStyle,
            //.blockBackgroundColor: blockBackgroundAttribute
        ])
    }

    private func styleGenericInlineCode(in str: NSMutableAttributedString) {
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code])
    }

    private func styleGenericLink(in str: NSMutableAttributedString, url: String) {
        str.addAttributes([
            .link: url,
            .foregroundColor: colors.link])
    }
}

// MARK: - Helpers
extension MDStyler {

    private func headingAttributes(for level: Int) -> (UIFont, UIColor, NSParagraphStyle) {
        switch level {
        case 1: return (fonts.heading1, colors.heading1, paragraphStyles.heading1)
        case 2: return (fonts.heading2, colors.heading2, paragraphStyles.heading2)
        case 3: return (fonts.heading3, colors.heading3, paragraphStyles.heading3)
        case 4: return (fonts.heading3, colors.heading3, paragraphStyles.heading3) // TODO: use .heading4
        case 5: return (fonts.heading3, colors.heading3, paragraphStyles.heading3) // TODO: use .heading5
        case 6: return (fonts.heading3, colors.heading3, paragraphStyles.heading3) // TODO: use .heading6
        default: return (fonts.heading1, colors.heading1, paragraphStyles.heading1)
        }
    }
}
