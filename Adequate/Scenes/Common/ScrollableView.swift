//
//  ScrollableView.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class ScrollableView<T: UIView>: UIView {
    public let scrollView = ParallaxScrollView()
    public let contentView = T()

    // TODO: add stateView?
    // TODO: add properties for ParallaxScrollView?

    // MARK: - Appearance

    override var backgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = backgroundColor
        }
    }

    // TODO: override .directionalLayoutMargins and .layoutMargins to add setter to adjust contentView?

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
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        //scrollView.preservesSuperviewLayoutMargins = true
        //contentView.preservesSuperviewLayoutMargins = true

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
            frameGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
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
    }

    override func layoutMarginsDidChange() {
        contentView.directionalLayoutMargins.leading = directionalLayoutMargins.leading
        contentView.directionalLayoutMargins.trailing = directionalLayoutMargins.trailing
    }
}

// MARK: - Themeable
extension ScrollableView: Themeable where T: Themeable {
    func apply(theme: ColorTheme) {
        backgroundColor = theme.systemBackground
        contentView.apply(theme: theme)
    }
}
