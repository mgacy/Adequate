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
        //log.verbose("blockQuote: '\(str.string)'")
        // ...
        str.addAttributes([.paragraphStyle: paragraphStyles.body])
    }

    func style(list str: NSMutableAttributedString, nestDepth: Int) {
        //log.debug("list: '\(str.string)'")
        // NOTE: DownStyler applies paragraph styling in `style(item:)`
        str.addAttributes([.paragraphStyle: paragraphStyles.list])
    }

    func style(listItemPrefix str: NSMutableAttributedString) {
        str.setAttributes(listPrefixAttributes)
    }

    func style(item str: NSMutableAttributedString, prefixLength: Int) {
        //log.verbose("item: '\(str.string)'")
        // NOTE: this is where DownStyler applies paragraph styling, rather than style(list:)
    }

    func style(codeBlock str: NSMutableAttributedString, fenceInfo: String?) {
        //log.verbose("codeBlock: '\(str.string)'")
        styleGenericCodeBlock(in: str)
    }

    func style(htmlBlock str: NSMutableAttributedString) {
        //log.verbose("htmlBlock: '\(str.string)'")
        styleGenericCodeBlock(in: str)
    }

    func style(customBlock str: NSMutableAttributedString) {}

    func style(paragraph str: NSMutableAttributedString) {
        str.addAttribute(for: .paragraphStyle, value: paragraphStyles.body)
    }

    func style(heading str: NSMutableAttributedString, level: Int) {
        //log.verbose("heading: '\(str.string)' - '\(level)")
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
        //log.verbose("text: '\(str.string)'")
        str.setAttributes([
            .font: fonts.body,
            .foregroundColor: colors.body])
    }

    func style(softBreak str: NSMutableAttributedString) {}

    func style(lineBreak str: NSMutableAttributedString) {}

    func style(code str: NSMutableAttributedString) {
        //log.verbose("code: '\(str.string)'")
        styleGenericInlineCode(in: str)
    }

    func style(htmlInline str: NSMutableAttributedString) {
        //log.verbose("htmlInline: '\(str.string)'")
        styleGenericInlineCode(in: str)
    }

    func style(customInline str: NSMutableAttributedString) {}

    func style(emphasis str: NSMutableAttributedString) {
        //log.verbose("emphasis: '\(str.string)'")
        str.updateExistingAttributes(for: .font) { (font: UIFont) in
            font.italic
        }
    }

    func style(strong str: NSMutableAttributedString) {
        //log.verbose("strong: '\(str.string)'")
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

    // MARK: - Common Styling

    private func styleGenericCodeBlock(in str: NSMutableAttributedString) {
        //log.verbose("styleGenericCodeBlock: '\(str.string)'")
        // ...
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code
            //.paragraphStyle: adjustedParagraphStyle,
            //.blockBackgroundColor: blockBackgroundAttribute
        ])
    }

    private func styleGenericInlineCode(in str: NSMutableAttributedString) {
        //log.verbose("styleGenericInlineCode: '\(str.string)'")
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code])
    }

    private func styleGenericLink(in str: NSMutableAttributedString, url: String) {
        str.addAttributes([
            .link: url,
            .foregroundColor: colors.link])
    }

    // MARK: - Helpers

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
