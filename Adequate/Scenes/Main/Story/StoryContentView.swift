//
//  StoryContentView.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/25/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class StoryContentView: UIView {

    var styler: MDStyler

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var body: String? {
        didSet {
            guard body != oldValue else {
                return
            }
            bodyText.markdownText = body
        }
    }

    // MARK: - Appearance

    override var backgroundColor: UIColor? {
        didSet {
            bodyText.backgroundColor = backgroundColor
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

    private let titleLabel = UILabel(style: StyleBook.Label.title)

    private lazy var bodyText: MDTextView = {
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

    override init(frame: CGRect) {
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
        addSubview(bodyText)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppTheme.spacing * 2.0),
            titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            // bodyText
            bodyText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppTheme.spacing),
            bodyText.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            bodyText.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            bodyText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppTheme.spacing * 2.0)
        ])
    }
}

// MARK: - Themeable
extension StoryContentView: Themeable {
    func apply(theme: ColorTheme) {
        textColor = theme.label

        styler.colors = MDColorCollection(theme: theme)
        try? bodyText.render()
    }
}
