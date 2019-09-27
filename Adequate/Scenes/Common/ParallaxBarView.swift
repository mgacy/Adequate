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

    /// Left inset for title label.
    // TODO: use enum with cases for number of bar button items?
    var leftLabelInset: CGFloat = 56.0 {
        didSet {
            titleLeftConstraint.constant = leftLabelInset
        }
    }

    /// Right inset for title label
    var rightLabelInset: CGFloat = 110.0 {
        didSet {
            titleRightConstraint.constant = rightLabelInset
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

    private(set) var progress: CGFloat = 0.0 {
        didSet {
            guard progress != oldValue else {
                return
            }
            updateLabel(for: progress)
            updateAlpha(for: progress)
        }
    }

    // MARK: - Subviews

    private var titleTopConstraint: NSLayoutConstraint!
    private var titleLeftConstraint: NSLayoutConstraint!
    private var titleRightConstraint: NSLayoutConstraint!
    private var backgroundHeightConstraint: NSLayoutConstraint!

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    // TODO: init(leftBarItems: Int, rightBarItems: Int) { ... }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        clipsToBounds = true
        addSubview(backgroundView)
        addSubview(titleLabel)
        isUserInteractionEnabled = false
        configureConstraints()
    }

    private func configureConstraints() {
        backgroundHeightConstraint = backgroundView.heightAnchor.constraint(equalToConstant: 0.0)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
        titleLeftConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftLabelInset)
        titleRightConstraint = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightLabelInset)

        NSLayoutConstraint.activate([
            // backgroundView
            backgroundHeightConstraint,
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // titleLabel
            titleTopConstraint,
            titleLeftConstraint,
            titleRightConstraint
        ])
    }

    // MARK: - A

    /// Update appearance based on y value of scroll view's contentOffset
    ///
    /// - Parameter yOffset: y value of scrollview `contentOffset`
    func updateProgress(yOffset: CGFloat) {
        let relativeHeight = -yOffset + coordinateOffset
        if relativeHeight >= frame.height {
            backgroundHeightConstraint.constant = 0
            progress = 0.0
        } else if relativeHeight <= inset {
            backgroundHeightConstraint.constant = frame.height
            progress = 1.0
        } else {
            // calculate progress
            guard frame.height > 0 else {
                backgroundHeightConstraint.constant = 0
                progress = 0.0
                return
            }
            let distance = frame.height - relativeHeight
            backgroundHeightConstraint.constant = distance
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
        backgroundView.backgroundColor = theme.backgroundColor
        // foreground
        titleLabel.textColor = theme.foreground.textColor
    }
}
