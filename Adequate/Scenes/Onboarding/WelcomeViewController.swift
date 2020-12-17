//
//  WelcomeViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/25/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base)
        label.font = FontBook.largeTitle
        label.text = L10n.appName
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = L10n.welcomeMessage
        return label
    }()

    private lazy var labelStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = UIStackView.spacingUseSystem
        view.isBaselineRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        view.addSubview(labelStack)
        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.readableContentGuide
        NSLayoutConstraint.activate([
            titleLabel.lastBaselineAnchor.constraint(equalTo: view.centerYAnchor),
            labelStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }
}

// MARK: - Themeable
extension WelcomeViewController: Themeable {

    func apply(theme: ColorTheme) {
        view.backgroundColor = theme.systemBackground
        titleLabel.textColor = theme.label
        bodyLabel.textColor = theme.secondaryLabel
    }
}
