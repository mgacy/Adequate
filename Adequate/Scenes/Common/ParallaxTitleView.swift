//
//  ParallaxTitleView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/30/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

class ParallaxTitleView: UIView {

    /// Percent progress of title as it moves to final position at center of navigation bar.
    var progress: CGFloat = 0.0 {
        didSet {
            guard progress != oldValue else {
                return
            }
            updateLabelPosition(for: progress)
        }
    }

    // MARK: - Appearance

    /// Title text.
    var text: String = "" {
        didSet {
            titleLabel.text = text
            updateLabelPosition(for: progress)
        }
    }

    /// Title text color.
    var textColor: UIColor = .label {
        didSet {
            titleLabel.textColor = textColor
        }
    }

    /// Title font.
    var font: UIFont = .systemFont(ofSize: 17.0, weight: .semibold) {
        didSet {
            titleLabel.font = font
            updateLabelPosition(for: progress)
        }
    }

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.text = text
        label.textColor = textColor
        label.font = font
        //label.isHidden = true
        //label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var titleVerticalConstraint: NSLayoutConstraint!

    /// The distance this view is inset from the bottom of the navigation bar's content view.
    private var bottomInset: CGFloat {
        guard let contentViewHeight = superview?.bounds.height else { return .zero}
        return contentViewHeight - frame.minY - bounds.height
    }

    override var intrinsicContentSize: CGSize {
        //return titleLabel.intrinsicContentSize
        return CGSize(width: 1000, height: 60)
    }

    // MARK: - Lifecycle

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
        preservesSuperviewLayoutMargins = true
        addSubview(titleLabel)
        let centerConstraint = titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerConstraint.priority = UILayoutPriority(rawValue: 275)
        titleVerticalConstraint = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleVerticalConstraint,
            centerConstraint
        ])
    }

    override func didMoveToSuperview() {
        superview(withName: "_UINavigationBarContentView")?.clipsToBounds = true
    }

    // MARK: - Layout

    private func updateLabelPosition(for progress: CGFloat) {
        let labelHeight = titleLabel.intrinsicContentSize.height
        // distance between bottom of label and bottom of view in final position
        let bottomPadding = (bounds.height - labelHeight) * 0.5
        // distance view is inset from the bottom of the navigation bar's content view.
        let yOffset = labelHeight + bottomPadding + bottomInset
        titleVerticalConstraint?.constant = (1 - progress) * yOffset
    }
}

/*
extension ParallaxTitleView {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            configureView(for: traitCollection)
        }
    }

    private func configureView(for traitCollection: UITraitCollection) {
        let contentSize = traitCollection.preferredContentSizeCategory
        font = .systemFont(ofSize: contentSize.navigationBarFontSize, weight: .semibold)
        //updateLabel(for: progress)
    }
}
*/
// MARK: - Themeable
extension ParallaxTitleView: Themeable {
    func apply(theme: ColorTheme) {
        textColor = theme.label
    }
}

// MARK: - Support
extension UIContentSizeCategory {
    var navigationBarFontSize: CGFloat {
        switch self {
        case .unspecified: return 17.0
        case .extraSmall, .small, .medium, .large: return 17.0
        case .extraLarge: return 19.0
        default: return 21.0
        }
    }
}
