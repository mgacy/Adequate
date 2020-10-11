//
//  ScrollablePadView.swift
//  Adequate
//
//  Created by Mathew Gacy on 1/8/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

// TODO: rename `SplitScrollableView`
final class ScrollablePadView<T: UIView>: UIView {
    public let scrollView = ParallaxScrollView()
    public let contentView = T()

    //public var verticalInset: CGFloat = 16.0

    override var backgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = backgroundColor
        }
    }

    // TODO: override insets and add setter to adjust constants on constraints for .secondaryColumnGuide?

    // MARK: Constraints

    /// Constraints for compact horizontal trait collection.
    private var compactConstraints: [NSLayoutConstraint] = []

    /// Constraints for regular horizontal trait collection irrespective of orientation.
    private var sharedRegularConstraints: [NSLayoutConstraint] = []

    /// Constraints for regular horizontal trait collection with portrait orientation.
    var portraitConstraints: [NSLayoutConstraint] = []

    /// Relative width of left column for regular horizontal trait collection with portrait orientation.
    private let portraitWidthMultiplier: CGFloat = 1.0 / 2.0

    /// Constraints for regular horizontal trait collection with landscape orientation.
    var landscapeConstraints: [NSLayoutConstraint] = []

    /// Relative width of right column for regular horizontal trait collection with landscape orientation.
    private let landscapeWidthMultiplier: CGFloat = 1.0 / 3.0

    public lazy var secondaryColumnGuide = UILayoutGuide()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //super.init(coder: aDecoder)
        //self.configure()
    }

    // MARK: - Configuration

    private func configure() {
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        setupConstraints()
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            // scrollView
            frameGuide.topAnchor.constraint(equalTo: topAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            // contentView
            contentView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            frameGuide.widthAnchor.constraint(equalTo: contentGuide.widthAnchor)
        ])

        // secondaryColumnGuide
        // TODO: maintain reference to trailing anchor so we can change constant when layout margins change?
        addLayoutGuide(secondaryColumnGuide)
        sharedRegularConstraints = [
            secondaryColumnGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            secondaryColumnGuide.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            secondaryColumnGuide.trailingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            secondaryColumnGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]

        // TODO: simply calculate constant for widthAnchor and modify that, rather than use 3 different properties?

        // Compact
        compactConstraints = [
            frameGuide.widthAnchor.constraint(equalTo: widthAnchor)
        ]

        // Portrait
        portraitConstraints = [
            frameGuide.widthAnchor.constraint(equalTo: widthAnchor, multiplier: portraitWidthMultiplier)
        ]

        // Landscape
        landscapeConstraints = [
            frameGuide.widthAnchor.constraint(equalTo: widthAnchor, multiplier: landscapeWidthMultiplier)
        ]
    }

    // MARK: - Layout

    override func layoutMarginsDidChange() {
        let priorMargins = contentView.layoutMargins // preserve existing top / bottom margins
        contentView.layoutMargins = UIEdgeInsets(top: priorMargins.top,
                                                 left: layoutMargins.left,
                                                 bottom: priorMargins.bottom,
                                                 right: layoutMargins.left)
    }
}

// MARK: - Constraints
extension ScrollablePadView {

    public func activateCompactConstraints() {
        NSLayoutConstraint.activate(compactConstraints)
    }

    public func deactivateCompactConstraints() {
        NSLayoutConstraint.deactivate(compactConstraints)
    }

    public func activateRegularConstraints() {
        NSLayoutConstraint.activate(sharedRegularConstraints)
        if frame.width > frame.height {
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
        }
    }

    public func deactivateRegularConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
        NSLayoutConstraint.deactivate(sharedRegularConstraints)
    }
}

// MARK: - Themeable
extension ScrollablePadView: Themeable where T: Themeable {
    func apply(theme: ColorTheme) {
        backgroundColor = theme.systemBackground
        contentView.apply(theme: theme)
    }
}
