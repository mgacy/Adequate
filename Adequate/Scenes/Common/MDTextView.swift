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

    var stylesheet: String?

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
        return try? down.toAttributedString(.smart, stylesheet: stylesheet)
    }

}
