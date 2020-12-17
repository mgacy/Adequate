//
//  LoadingView.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/25/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    // MARK: - Subviews

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.overrideUserInterfaceStyle = .dark
        view.color = .secondaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var fakeImageView: UIView = {
        let view = UIView()
        view.overrideUserInterfaceStyle = .dark
        view.layer.cornerRadius = AppTheme.CornerRadius.small
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        addSubview(fakeImageView)

        addSubview(activityIndicator)
        setupConstraints()
        activityIndicator.startAnimating()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            // fakeImageView
            fakeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            fakeImageView.topAnchor.constraint(equalTo: topAnchor),
            fakeImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fakeImageView.widthAnchor.constraint(equalTo: fakeImageView.heightAnchor)
        ])
        // Needed to ensure layout by time view is presented
        layoutIfNeeded()
    }
}
