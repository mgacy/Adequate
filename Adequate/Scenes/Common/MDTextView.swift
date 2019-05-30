//
//  MDTextView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Down

/// Wrapper around UITextView to support embedding in UIScrollView with Markdown support.
class MDTextView: UIView {

    var paragraphStyle: MDParagraphStyle = .normal
    var stylesheet: String? = "* {font-family: Helvetica } code, pre { font-family: Menlo }"

    private var _markdown: String!
    var markdown: String! {
        set {
            guard let attributedString = attributedString(from: newValue) else {
                return
            }
            _markdown = newValue
            textView.attributedText = attributedString
            textView.textColor = textColor
        }
        get { return _markdown }
    }

    override var backgroundColor: UIColor? {
        didSet {
            textView.backgroundColor = backgroundColor
        }
    }

    // UITextView Properties
    var text: String! {
        set { textView.text = newValue }
        get { return textView.text }
    }

    var attributedText: NSAttributedString! {
        set { textView.attributedText = newValue }
        get { return textView.attributedText }
    }

    var font: UIFont? {
        set { textView.font = newValue }
        get { return textView.font }
    }

    private var _textColor: UIColor? = .black
    var textColor: UIColor? {
        set {
            _textColor = newValue
            textView.textColor = newValue
        }
        get { return _textColor }
    }

    // MARK: - Interface Elements

    private let textView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false

        // https://kenb.us/uilabel-vs-uitextview
        view.contentInset = .zero
        view.contentInsetAdjustmentBehavior = .never
        view.textContainerInset = .zero // UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        view.textContainer.lineFragmentPadding = 0
        view.layoutManager.usesFontLeading = false

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    convenience init(stylesheet: String?) {
        self.init(frame: CGRect.zero)
        self.stylesheet = stylesheet
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    // MARK: - Configuration

    private func configure() {
        //textView.delegate = self
        addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    /// TODO: make throwing?
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
