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
    typealias Dependencies = HasNotificationManager & HasUserDefaultsManager

    // TODO: improve handling of .init
    let notificationManager: NotificationManagerType
    let userDefaultsManager: UserDefaultsManagerType
    weak var delegate: VoidDismissalDelegate?

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = L10n.welcomeNotificationsTitle
        // TODO: use FontBook
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        //label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = L10n.welcomeNotificationsBody
        label.textColor = ColorCompatibility.secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        //label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
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

    private let notNowButton: UIButton = {
        let button = UIButton(type: .custom)
        // TODO: use bolder font?
        //button.titleLabel?.font = FontBook.boldButton
        //button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitle(L10n.nowNow, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = button.tintColor.cgColor
        button.setTitleColor(button.tintColor, for: .normal)
        //button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleNotNowTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let okButton: UIButton = {
        let button = UIButton(type: .custom)
        // TODO: use bolder font?
        //button.titleLabel?.font = FontBook.boldButton
        //button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitle(L10n.ok, for: .normal)
        button.layer.cornerRadius = 5
        //button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        button.addTarget(self, action: #selector(handleOKTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [notNowButton, okButton])
        view.axis = .horizontal
        // Alignment
        view.alignment = .fill
        view.alignment = .top
        view.alignment = .firstBaseline
        //view.alignment = .center
        //view.alignment = .bottom
        view.distribution = .fillEqually
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // TODO: stackView?

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.notificationManager = dependencies.notificationManager
        self.userDefaultsManager = dependencies.userDefaultsManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.addSubview(labelStack)
        view.addSubview(buttonStack)
        self.view = view
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = ColorCompatibility.systemBackground
    }

    private func setupConstraints() {
        // TODO: use readableContentGuide
        NSLayoutConstraint.activate([
            // labelStack
            labelStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
            labelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            labelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            // buttonStack
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            buttonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
    }

    // MARK: - Actions

    @objc private func handleNotNowTapped(_ sender: UIButton) {
        userDefaultsManager.showNotifications = false
        userDefaultsManager.hasShownOnboarding = true
        delegate?.dismiss()
    }

    @objc private func handleOKTapped(_ sender: UIButton) {
        notificationManager.requestAuthorization()
            .ensure({ $0 })
            .then({ _ -> Promise<Void> in
                self.userDefaultsManager.showNotifications = true
                return self.notificationManager.registerForPushNotifications()
            })
            .catch({ error in
                log.error("\(#function): \(error)")
                self.userDefaultsManager.showNotifications = false
            })
            .always({
                self.userDefaultsManager.hasShownOnboarding = true
                self.delegate?.dismiss()
            })
    }
}
