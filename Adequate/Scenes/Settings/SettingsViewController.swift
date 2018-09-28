//
//  SettingsViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Config

enum SupportAddress: String {
    case web = "example.com"
    case email = "support@example.com"
    case twitter = "@example"

    var url: URL? {
        switch self {
        case .web:
            return URL(string: "https://\(rawValue)")
        case .email:
            return URL(string: "mailto:\(rawValue)")
        case .twitter:
            let application = UIApplication.shared
            if let appURL = URL(string: "twitter://user?screen_name=\(rawValue)"), application.canOpenURL(appURL) {
                return appURL
            } else {
                return URL(string: "https://twitter.com/\(rawValue)")
            }
        }
    }

}

// MARK: - Delegate Protocol

protocol SettingsViewControllerDelegate: class {
    func dismiss(_: Void)
}

// MARK: - View

class SettingsViewController: UITableViewController {

    weak var delegate: SettingsViewControllerDelegate? = nil
    var notificationManager: NotificationManagerType!

    // MARK: - Interface

    private var notificationCell: UITableViewCell = UITableViewCell()

    private let notificationSwitch: UISwitch = {
        let view = UISwitch()
        return view
    }()

    private lazy var webCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Web"
        cell.detailTextLabel?.text = SupportAddress.web.rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    private lazy var emailCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Email"
        cell.detailTextLabel?.text = SupportAddress.email.rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    private lazy var twitterCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Twitter"
        cell.detailTextLabel?.text = SupportAddress.twitter.rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        // Section 1
        notificationCell.textLabel?.text = "Daily Notifications"
        notificationCell.accessoryView = notificationSwitch
        notificationCell.selectionStyle = .none
        notificationSwitch.addTarget(self, action: #selector(tappedSwitch(_:)), for: .touchUpInside)

        // Section 2
        // ...
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                            action: #selector(didPressDone(_:)))
        /// TODO: set state of notificationSwitch
        let defaults = UserDefaults.standard
        let showNotifications = defaults.bool(forKey: "showNotifications")
        notificationSwitch.setOn(showNotifications, animated: false)
    }

    // MARK: - UITableViewDatasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        default: fatalError("Unknown number of sections in \(description)")
        }
    }

    // Return the row for the corresponding section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return notificationCell
            default: fatalError("Unknown row in section 0 of \(description)")
            }
        case 1:
            switch indexPath.row {
            case 0: return webCell
            case 1: return emailCell
            case 2: return twitterCell
            default: fatalError("Unknown row in section 1 of \(description)")
            }
        default: fatalError("Unknown section in \(description)")
        }
    }

    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Notifications"
        case 1: return "Support"
        default: fatalError("Unknown section in \(description)")
        }
    }

    // MARK: - UITableViewDelegate

    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let application = UIApplication.shared
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            guard let webURL = URL(string: "https://\(SupportAddress.web.rawValue)") else {
                print("ERROR: bad web support address")
                return
            }
            application.open(webURL)
        case (1,1):
            /// TODO: open email or email composer?
            guard let emailURL = URL(string: "mailto:\(SupportAddress.email.rawValue)") else {
                print("ERROR: bad email support address")
                return
            }
            application.open(emailURL)
        case (1,2):
            guard
                let appURL = URL(string: "twitter://user?screen_name=\(SupportAddress.twitter.rawValue)"),
                let webURL = URL(string: "https://twitter.com/\(SupportAddress.twitter.rawValue)") else {
                    print("ERROR: bad twitter support address")
                    return
            }
            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                application.open(webURL)
            }
        default:
            return
        }
    }

    // MARK: - Actions

    @objc private func didPressDone(_ sender: UIBarButtonItem) {
        delegate?.dismiss(())
    }

    @objc private func tappedSwitch(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        switch sender.isOn {
        case true:
            notificationManager.registerForPushNotifications().then({ _ in
                UserDefaults.standard.set(true, forKey: "showNotifications")
            }).catch({ [weak self] error in
                print("ERROR: \(error.localizedDescription)")
                /// TODO: how best to handle this? Display alert with option to go to Settings?
                self?.notificationSwitch.setOn(false, animated: true)
            })
        case false:
            defaults.set(false, forKey: "showNotifications")
        }
    }

}
