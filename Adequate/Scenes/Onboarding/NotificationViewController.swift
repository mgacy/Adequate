//
//  NotificationViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/25/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

final class NotificationViewController: UIViewController {
    typealias Dependencies = HasUserDefaultsManager & NotificationManagerProvider

    // TODO: improve handling of .init
    let notificationManager: NotificationManagerType
    let userDefaultsManager: UserDefaultsManagerType
    weak var delegate: OnboardingDismissalDelegate?

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base)
        label.numberOfLines = 0
        label.font = FontBook.largeTitle
        label.text = L10n.welcomeNotificationsTitle
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = L10n.welcomeNotificationsBody
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

    private let notNowButton: UIButton = {
        let button = UIButton(style: StyleBook.Button.secondary)
        button.setTitle(L10n.nowNow, for: .normal)
        button.addTarget(self, action: #selector(handleNotNowTapped(_:)), for: .touchUpInside)
        // TODO: add button.accessibilityLabel
        return button
    }()

    private let okButton: UIButton = {
        let button = UIButton(style: StyleBook.Button.standard)
        button.setTitle(L10n.ok, for: .normal)
        button.addTarget(self, action: #selector(handleOKTapped(_:)), for: .touchUpInside)
        // TODO: add button.accessibilityLabel
        return button
    }()

    private lazy var buttonStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [notNowButton, okButton])
        view.axis = .horizontal
        view.alignment = .firstBaseline
        view.distribution = .fillEqually
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.notificationManager = dependencies.makeNotificationManager()
        self.userDefaultsManager = dependencies.userDefaultsManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        view.addSubview(labelStack)
        view.addSubview(buttonStack)
        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.readableContentGuide

        let titleBaseline = titleLabel.lastBaselineAnchor.constraint(equalTo: view.centerYAnchor)

        NSLayoutConstraint.activate([
            titleBaseline,
            // labelStack
            labelStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            // buttonStack
            buttonStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
    }

    // MARK: - Actions

    @objc private func handleNotNowTapped(_ sender: UIButton) {
        userDefaultsManager.showNotifications = false
        userDefaultsManager.hasShownOnboarding = true
        delegate?.finish(with: .noNotifications)
    }

    @objc private func handleOKTapped(_ sender: UIButton) {
        notificationManager.requestAuthorization()
            .then({ [self] allowNotifications in
                // Hand off
                self.userDefaultsManager.showNotifications = allowNotifications
                switch allowNotifications {
                case true:
                    self.delegate?.finish(with: .allowNotifications(notificationManager))
                case false:
                    self.delegate?.finish(with: .noNotifications)
                }
            })
            .catch({ error in
                log.error("\(#function): \(error)")
                self.userDefaultsManager.showNotifications = false
            })
            .always({
                self.userDefaultsManager.hasShownOnboarding = true
            })
    }
}

// MARK: - UITraitEnvironment
extension NotificationViewController {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // We need to handle `CALayer` manually
            let resovedColor = UIColor.label.resolvedColor(with: traitCollection)
            notNowButton.layer.borderColor = resovedColor.cgColor
        }
    }
}

// MARK: - Themeable
extension NotificationViewController: Themeable {

    func apply(theme: ColorTheme) {
        view.backgroundColor = theme.systemBackground
        titleLabel.textColor = theme.label
        bodyLabel.textColor = theme.secondaryLabel

        //StyleBook.Button.secondary(color: theme.label).apply(to: notNowButton)
        notNowButton.layer.borderColor = theme.label.cgColor
        notNowButton.setTitleColor(theme.label, for: .normal)

        okButton.backgroundColor = theme.label
        okButton.setTitleColor(theme.systemBackground, for: .normal)
    }
}
