//
//  DealContentView.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class DealContentView: UIView {

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

    // TODO: remove in favor of simply relying on apply(theme:)?
    override var backgroundColor: UIColor? {
        didSet {
            featuresText.backgroundColor = backgroundColor
            forumButton.setTitleColor(backgroundColor, for: .normal)
            specsText.backgroundColor = backgroundColor
        }
    }

    // TODO: remove in favor of simply relying on apply(theme:)?
    private var _textColor: UIColor? = .black
    var textColor: UIColor? {
        set {
            _textColor = newValue
            titleLabel.textColor = newValue
            featuresText.textColor = newValue
            specsText.textColor = newValue
        }
        get { return _textColor }
    }

    // MARK: - Subviews

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontBook.mainTitle
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var featuresText: MDTextView = {
        let view = MDTextView(styler: styler)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let forumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(L10n.Comments.count(0), for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = button.tintColor
        return button
    }()

    lazy var specsText: MDTextView = {
        let view = MDTextView(styler: styler)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(styler: MDStyler = MDStyler()) {
        self.styler = styler
        super.init(frame: CGRect.zero)
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
        let buttonWidth: CGFloat = 200.0
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppTheme.sideMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppTheme.spacing),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: AppTheme.widthInset),
            // featuresText
            featuresText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppTheme.sideMargin),
            featuresText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppTheme.spacing * 2.0),
            featuresText.widthAnchor.constraint(equalTo: widthAnchor, constant: AppTheme.widthInset),
            // forumButton
            forumButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            forumButton.topAnchor.constraint(equalTo: featuresText.bottomAnchor, constant: AppTheme.spacing * 2.0),
            forumButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            // specsText
            specsText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppTheme.sideMargin),
            specsText.topAnchor.constraint(equalTo: forumButton.bottomAnchor, constant: AppTheme.spacing * 2.0),
            specsText.widthAnchor.constraint(equalTo: widthAnchor, constant: AppTheme.widthInset),
            specsText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppTheme.spacing)
        ])
    }
}

// MARK: - Themeable
extension DealContentView: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        forumButton.backgroundColor = theme.accentColor
        // backgroundColor
        backgroundColor = theme.backgroundColor
        featuresText.backgroundColor = theme.backgroundColor
        forumButton.setTitleColor(theme.backgroundColor, for: .normal)
        // TODO: setTitleColor for other states?
        specsText.backgroundColor = theme.backgroundColor
        // foreground
        titleLabel.textColor = theme.foreground.textColor

        styler.colors = ColorCollection(theme: theme)
        try? featuresText.render()
        try? specsText.render()
    }

    func apply(theme: ColorTheme) {
        // accentColor
        forumButton.backgroundColor = theme.tint

        // backgroundColor
        backgroundColor = theme.systemBackground
        featuresText.backgroundColor = theme.systemBackground
        forumButton.setTitleColor(theme.systemBackground, for: .normal)
        // TODO: forumButton.setTitleColor(theme.?, for: .disabled)
        specsText.backgroundColor = theme.systemBackground

        // foreground - text
        titleLabel.textColor = theme.label

        styler.colors = ColorCollection(theme: theme)
        try? featuresText.render()
        try? specsText.render()
    }
}
