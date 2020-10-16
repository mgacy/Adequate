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
        label.text = L10n.appName
        label.textColor = ColorCompatibility.label
        // TODO: use FontBook
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base)
        label.numberOfLines = 0
        label.text = L10n.welcomeMessage
        label.textColor = ColorCompatibility.secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var labelStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        //view.spacing = 8.0
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
        view.backgroundColor = ColorCompatibility.systemBackground
        view.addSubview(labelStack)
        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.readableContentGuide
        //let guide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            labelStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
            labelStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }
}
