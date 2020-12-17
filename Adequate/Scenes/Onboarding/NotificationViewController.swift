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
        label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
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
        button.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        // TODO: add button.accessibilityLabel
        return button
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
        view.addSubview(notNowButton)
        view.addSubview(okButton)
        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.readableContentGuide

        let titleBaseline = titleLabel.lastBaselineAnchor.constraint(equalTo: view.centerYAnchor)
        titleBaseline.priority = UILayoutPriority(750)

        let buttonWidthConstraint = notNowButton.widthAnchor.constraint(equalTo: okButton.widthAnchor, multiplier: 1.0)
        buttonWidthConstraint.priority = UILayoutPriority(250)
        NSLayoutConstraint.activate([
            titleBaseline,
            // labelStack
            labelStack.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            labelStack.bottomAnchor.constraint(lessThanOrEqualTo: notNowButton.topAnchor),
            labelStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            // notNowButton
            notNowButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            notNowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            notNowButton.heightAnchor.constraint(equalTo: okButton.heightAnchor),
            // okButton
            okButton.leadingAnchor.constraint(equalTo: notNowButton.trailingAnchor, constant: AppTheme.spacing),
            okButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonWidthConstraint
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
