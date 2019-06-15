//
//  ParallaxBarView.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class ParallaxBarView: UIView {

    /// Difference between coordinate system of this view and that of the scroll view.
    var coordinateOffset: CGFloat = 0.0

    /// Space above the 'title bar' (occupied by the status bar).
    var inset: CGFloat = 0.0

    /// Insets for titleLabel.
    // TODO: use enum with cases for number of bar button items?
    var leftLabelInset: CGFloat = 56.0
    var rightLabelInset: CGFloat = 110.0

    private(set) var progress: CGFloat = 0.0 {
        didSet {
            guard progress != oldValue else {
                return
            }
            updateLabel(for: progress)
            updateAlpha(for: progress)
        }
    }

    var text: String = "" {
        didSet {
            titleLabel.text = text
        }
    }

    var textColor: UIColor = .black {
        didSet {
            titleLabel.textColor = textColor
        }
    }

    var font: UIFont = .systemFont(ofSize: 17.0, weight: .semibold) {
        didSet {
            titleLabel.font = font
        }
    }

    // MARK: - Subviews

    private var titleTopConstraint: NSLayoutConstraint!

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        clipsToBounds = true
        addSubview(titleLabel)
        isUserInteractionEnabled = false
        configureConstraints()
    }

    private func configureConstraints() {
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
        NSLayoutConstraint.activate([
            titleTopConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftLabelInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightLabelInset)
        ])
    }

    // MARK: - A

    /// Update appearance based on y value of scroll view's contentOffset
    ///
    /// - Parameter yOffset: y value of scrollview `contentOffset`
    func updateProgress(yOffset: CGFloat) {
        let relativeHeight = -yOffset + coordinateOffset
        if relativeHeight >= frame.height {
            progress = 0.0
        } else if relativeHeight <= inset {
            progress = 1.0
        } else {
            // calculate progress
            guard frame.height > 0 else {
                progress = 0.0
                return
            }
            let distance = frame.height - relativeHeight
            progress = distance / (frame.height - inset)
        }
    }

    // MARK: - B

    private func updateLabel(for progress: CGFloat) {
        let labelHeight = titleLabel.intrinsicContentSize.height

        /// space between bottom of label and bottom of view in final position
        let bottomPadding = (frame.height - labelHeight - inset) * 0.5
        /// space between top of label  and bottom of view in final position
        let yOffset = bottomPadding + labelHeight

        titleTopConstraint.constant = -(progress * yOffset)
    }

    private func updateAlpha(for progress: CGFloat) {
        let bgColor = (backgroundColor ?? .red).withAlphaComponent(progress)
        backgroundColor = bgColor
    }
}

// MARK: - Themeable
extension ParallaxBarView: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        // backgroundColor
        backgroundColor = theme.backgroundColor.withAlphaComponent(0.0)
        // foreground
        titleLabel.textColor = theme.foreground.textColor
    }
}
