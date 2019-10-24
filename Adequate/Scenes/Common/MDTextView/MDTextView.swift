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

    // MARK: - Properties

    var styler: Styler

    private var _markdownText: String! = ""
    var markdownText: String! {
        set {
            guard newValue != _markdownText else {
                return
            }
            _markdownText = newValue
            try? render()
        }
        get { return _markdownText }
    }

    // MARK: - Lifecycle

    convenience init(styler: Styler = MDStyler()) {
        self.init(frame: CGRect.zero, styler: styler)
    }

    init(frame: CGRect, styler: Styler) {
        self.styler = styler
        super.init(frame: frame, textContainer: nil)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure() {
        adjustsFontForContentSizeCategory = true
        isEditable = false
        isScrollEnabled = false
        //isSelectable = false

        // https://kenb.us/uilabel-vs-uitextview
        contentInset = .zero
        contentInsetAdjustmentBehavior = .never
        textContainerInset = .zero // UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        textContainer.lineFragmentPadding = 0
        layoutManager.usesFontLeading = false
    }

    func render() throws {
        //let currentTextColor = textColor
        //let down = Down(markdownString: _markdownText)
        //attributedText = try down.toAttributedString(styler: styler)
        attributedText = try attributedString(from: _markdownText)
        //textColor = currentTextColor
    }

    private func attributedString(from markdown: String) throws -> NSAttributedString {
        let down = Down(markdownString: markdown)
        return try down.toAttributedString(styler: styler)
    }
}

// MARK: - Themeable
extension MDTextView: Themeable {
    func apply(theme: ColorTheme) {
        guard let mdStyler = styler as? MDStyler else {
            log.error("Unable to apply theme to \(self.description) without MDStyler")
            return
        }
        mdStyler.colors = ColorCollection(theme: theme)
        backgroundColor = theme.systemBackground
        //textColor = theme.label
        if _markdownText != "" {
            try? render()
        }
    }
}
