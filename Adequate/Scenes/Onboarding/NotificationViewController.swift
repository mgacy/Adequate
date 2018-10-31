//
//  NotificationViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/25/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class NotificationViewController: UIViewController {
    typealias Dependencies = HasNotificationManager

    /// TODO: improve handling of .init
    let notificationManager: NotificationManagerType
    weak var delegate: VoidDismissalDelegate?

    private enum Strings {
        static let title = "Enable Notifications?"
        static let body = "Enable notifications so Adequate can alert you when meh offers a new daily deal."
        static let cancel = "Not Now"
        static let ok = "OK"
    }

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = Strings.title
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = Strings.body
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        button.setTitle(Strings.cancel, for: .normal)
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
        button.setTitle(Strings.ok, for: .normal)
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

    /// TODO: stackView?

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.notificationManager = dependencies.notificationManager
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

    func setupView() {
        view.backgroundColor = .white
        setupConstraints()
    }

    func setupConstraints() {
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

    // MARK: - A

    @objc private func handleNotNowTapped(_ sender: UIButton) {
        /// TODO: should NotificationManager be responsible for handling this?
        UserDefaults.standard.set(false, forKey: "showNotifications")
        delegate?.dismiss()
    }

    @objc private func handleOKTapped(_ sender: UIButton) {
        notificationManager.registerForPushNotifications()
            .then({ [weak self] _ in
                self?.delegate?.dismiss()
            }).catch({ error in
                print("ERROR: \(error)")
            })
    }

}
