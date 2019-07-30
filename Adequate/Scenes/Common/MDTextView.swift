//
//  MDTextView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Down


class MDTextView: UITextView {

    var paragraphStyle: MDParagraphStyle = .normal
    var stylesheet: String? = "* {font-family: Helvetica } code, pre { font-family: Menlo }"

    private var _markdown: String!
    var markdown: String! {
        set {
            let currentTextColor = textColor
            guard let attributedString = attributedString(from: newValue) else {
                return
            }
            _markdown = newValue
            attributedText = attributedString
            // TODO: specify color in stylesheet
            textColor = currentTextColor
        }
        get { return _markdown }
    }

    // MARK: - Lifecycle

    convenience init(stylesheet: String?) {
        self.init(frame: CGRect.zero)
        self.stylesheet = stylesheet
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure() {
        adjustsFontForContentSizeCategory = true
        isScrollEnabled = false
        isEditable = false

        // https://kenb.us/uilabel-vs-uitextview
        contentInset = .zero
        contentInsetAdjustmentBehavior = .never
        textContainerInset = .zero // UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        textContainer.lineFragmentPadding = 0
        layoutManager.usesFontLeading = false
    }

    // TODO: make throwing?
    private func attributedString(from markdownString: String) -> NSAttributedString? {
        let down = Down(markdownString: markdownString)
        //return try? down.toAttributedString(.smart, stylesheet: stylesheet)

        guard
            let html = try? down.toHTML(.smart),
            let stylesheet = stylesheet,
            let attributedString = try? NSMutableAttributedString(htmlString: "<style>" + stylesheet + "</style>" + html) else {
                return nil
        }

        // Add paragraph styling
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: makeParagraphStyle()]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }

    private func makeParagraphStyle() -> NSMutableParagraphStyle {
        // TODO: obtain value from attributes of font?
        let indent: CGFloat = 15.0
        let pGraphSpacing: CGFloat = 8.0

        let paragraphStyle = NSMutableParagraphStyle()

        /// The indentation of the first line of the receiver.
        paragraphStyle.firstLineHeadIndent = 0.0

        /// The indentation of the receiver’s lines other than the first.
        paragraphStyle.headIndent = self.paragraphStyle.headIndent

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

// MARK: - Add Paragraph Styling

enum MDParagraphStyle {
    case normal
    case list

    /// The indentation of the receiver’s lines other than the first.
    var headIndent: CGFloat {
        switch self {
        case .normal: return 0.0
        case .list: return 15.0
        }
    }
}

extension NSMutableAttributedString {

    /// Instantiates an attributed string with the given HTML string
    ///
    /// - Parameter htmlString: An HTML string
    /// - Throws: `HTMLDataConversionError` or an instantiation error
    convenience init(htmlString: String) throws {
        guard let data = htmlString.data(using: String.Encoding.utf8) else {
            throw DownErrors.htmlDataConversionError
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
        ]
        try self.init(data: data, options: options, documentAttributes: nil)
    }

}
