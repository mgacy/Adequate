//
//  StoryContentView.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/25/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class StoryContentView: UIView {

    //var styler: MDStyler

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

    // TODO: remove in favor of simply relying on apply(theme:)?
    private var _textColor: UIColor? = .black
    var textColor: UIColor? {
        set {
            _textColor = newValue
            titleLabel.textColor = newValue
            bodyText.textColor = newValue
        }
        get { return _textColor }
    }

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontBook.mainTitle
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyText: MDTextView = {
        let styler = MDStyler()
        let view = MDTextView(styler: styler)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    // TODO: init with MDStyler?
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
        titleLabel.textColor = theme.label
        bodyText.apply(theme: theme)
    }
}
