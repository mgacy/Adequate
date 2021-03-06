//
//  DealContentView.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class DealContentView: UIView {

    var styler: MDStyler

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var features: String! {
        didSet {
            guard features != oldValue else {
                return
            }
            featuresText.markdownText = features
        }
    }

    var commentCount: Int? {
        didSet {
            if let count = commentCount {
                forumButton.isHidden = false
                forumButton.isEnabled = true
                forumButton.setTitle(L10n.Comments.count(count), for: .normal)
            } else {
                forumButton.isEnabled = false
                forumButton.isHidden = true
            }
        }
    }

    var specifications: String? {
        didSet {
            guard specifications != oldValue else {
                return
            }
            specsText.markdownText = specifications
        }
    }

    // MARK: - Appearance

    override var backgroundColor: UIColor? {
        didSet {
            featuresText.backgroundColor = backgroundColor
            specsText.backgroundColor = backgroundColor
        }
    }

    private var _textColor: UIColor? = .label
    var textColor: UIColor? {
        get { return _textColor }
        set {
            _textColor = newValue
            titleLabel.textColor = newValue
        }
    }

    // MARK: - Subviews

    let titleLabel = UILabel(style: StyleBook.Label.title)

    lazy var featuresText: MDTextView = {
        let view = MDTextView(styler: styler)
        StyleBook.TextView.base.apply(to: view)
        return view
    }()

    let forumButton: MGButton<ButtonAnimator> = {
        let button = MGButton(animationDelegate: ButtonAnimator.self)
        StyleBook.Button.standard.apply(to: button)
        //StyleBook.Button.wideInsets.apply(to: button)
        button.backgroundColor = button.tintColor
        button.setTitle(L10n.Comments.count(0), for: .normal)
        return button
    }()

    lazy var specsText: MDTextView = {
        let view = MDTextView(styler: styler)
        StyleBook.TextView.base.apply(to: view)
        return view
    }()

    // MARK: - Lifecycle

    init(styler: MDStyler = MDStyler()) {
        self.styler = styler
        super.init(frame: CGRect.zero)
        self.configure()
    }

    override public init(frame: CGRect) {
        self.styler = MDStyler()
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(titleLabel)
        addSubview(featuresText)
        addSubview(forumButton)
        addSubview(specsText)
        setupConstraints()
    }

    private func setupConstraints() {
        // TODO: if not using button insets, make button some multiplier of view width
        let buttonWidth: CGFloat = 200.0
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            // featuresText
            featuresText.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            featuresText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppTheme.spacing * 2.0),
            featuresText.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            // forumButton
            forumButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            forumButton.topAnchor.constraint(equalTo: featuresText.bottomAnchor, constant: AppTheme.spacing * 2.0),
            // TODO: replace with setting button insets
            forumButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            // specsText
            specsText.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            specsText.topAnchor.constraint(equalTo: forumButton.bottomAnchor, constant: AppTheme.spacing * 2.0),
            specsText.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            specsText.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}

// MARK: - Themeable
extension DealContentView: Themeable {
    func apply(theme: ColorTheme) {
        backgroundColor = theme.systemBackground
        textColor = theme.label

        StyleBook.Button.standard(theme: theme).apply(to: forumButton)
        styler.colors = MDColorCollection(theme: theme)
        try? featuresText.render()
        try? specsText.render()
    }
}
