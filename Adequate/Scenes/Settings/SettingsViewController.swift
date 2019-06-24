//
//  SettingsViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol

protocol SettingsViewControllerDelegate: class {
    func showAbout()
    func showReview()
    func dismiss(_: Void)
}

// MARK: - View

class SettingsViewController: UITableViewController {
    typealias Dependencies = HasNotificationManager & HasUserDefaultsManager

    weak var delegate: SettingsViewControllerDelegate? = nil
    private let notificationManager: NotificationManagerType
    //private let themeManager: ThemeManagerType
    private let userDefaultsManager: UserDefaultsManagerType
    //private var observationTokens: [ObservationToken] = []

    // MARK: - Subviews

    private let notificationHeader: UILabel = {
        let view = PaddingLabel(padding: UIEdgeInsets(top: 32.0, left: 16.0, bottom: 8.0, right: 16.0))
        view.font = UIFont.preferredFont(forTextStyle: .footnote)
        view.textColor = .gray
        view.text = L10n.notifications.uppercased()
        return view
    }()

    // TODO: configure this cell like all the others
    private let notificationCell: UITableViewCell = UITableViewCell()

    private let notificationSwitch: UISwitch = {
        let view = UISwitch()
        return view
    }()

    private let supportHeader: UILabel = {
        let view = PaddingLabel(padding: UIEdgeInsets(top: 24.0, left: 16.0, bottom: 8.0, right: 16.0))
        view.font = UIFont.preferredFont(forTextStyle: .footnote)
        view.textColor = .gray
        view.text = L10n.support.uppercased()
        return view
    }()

    private lazy var webCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.web
        cell.detailTextLabel?.text = SupportAddress.web.rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    private lazy var emailCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.email
        cell.detailTextLabel?.text = SupportAddress.email.rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    private lazy var twitterCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.twitter
        cell.detailTextLabel?.text = SupportAddress.twitter.rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    private let supportFooter: UILabel = {
        let view = PaddingLabel()
        view.numberOfLines = 0
        view.font = UIFont.preferredFont(forTextStyle: .footnote)
        view.textColor = .gray
        view.text = L10n.unofficialAppDisclaimer
        return view
    }()

    private lazy var aboutCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.about
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    private lazy var reviewCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.reviewApp
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.notificationManager = dependencies.notificationManager
        //self.themeManager = dependencies.themeManager
        self.userDefaultsManager = dependencies.userDefaultsManager
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        // Section 1
        notificationCell.textLabel?.text = L10n.dailyNotifications
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

    //deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        title = L10n.settings
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                            action: #selector(didPressDone(_:)))

        //apply(theme: themeManager.theme)

        // TODO: move this logic into NotificationManager as `verifyNotificationSetting`?
        if userDefaultsManager.showNotifications {
            notificationManager.isAuthorized()
                .then({ isAuthorized in
                    if isAuthorized {
                        self.notificationSwitch.setOn(true, animated: false)
                    } else {
                        self.userDefaultsManager.showNotifications = false
                        self.notificationSwitch.setOn(false, animated: false)
                    }
                })
        } else {
            notificationSwitch.setOn(false, animated: false)
        }
    }
    /*
    private func setupObservations() -> [ObservationToken] {
        let themeToken = themeManager.addObserver(self)
        return [themeToken]
    }
    */
    // MARK: - UITableViewDatasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 2
        default: fatalError("Unknown number of sections in \(description)")
        }
    }

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
        case 2:
            switch indexPath.row {
            case 0: return aboutCell
            case 1: return reviewCell
            default: fatalError("Unknown row in section 2 of \(description)")
            }
        default: fatalError("Unknown section in \(description)")
        }
    }
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Notifications"
        case 1: return "Support"
        default: fatalError("Unknown section in \(description)")
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "This is an unofficial app. Please direct any issues to the developer, not to Meh."
        default: fatalError("Unknown section in \(description)")
        }
    }
    */
    // MARK: - UITableViewDelegate

    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let application = UIApplication.shared
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            guard let webURL = URL(string: "https://\(SupportAddress.web.rawValue)") else {
                log.error("Bad web support address")
                return
            }
            application.open(webURL)
        case (1, 1):
            // TODO: open email or email composer?
            guard let emailURL = URL(string: "mailto:\(SupportAddress.email.rawValue)") else {
                log.error("Bad email support address")
                return
            }
            application.open(emailURL)
        case (1, 2):
            guard
                let appURL = URL(string: "twitter://user?screen_name=\(SupportAddress.twitter.rawValue)"),
                let webURL = URL(string: "https://twitter.com/\(SupportAddress.twitter.rawValue)") else {
                    log.error("Bad twitter support address")
                    return
            }
            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                application.open(webURL)
            }
        case (2, 0):
            delegate?.showAbout()
        case (2, 1):
            //delegate?.showReview()
            showDisabledReviewAlert()
        default:
            return
        }
    }

    // MARK: - Actions

    @objc private func didPressDone(_ sender: UIBarButtonItem) {
        delegate?.dismiss(())
    }

    @objc private func tappedSwitch(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            notificationManager.registerForPushNotifications().then({ [weak self] _ in
                self?.userDefaultsManager.showNotifications = true
            }).catch({ [weak self] error in
                log.error("\(#function): \(error.localizedDescription)")
                self?.notificationSwitch.setOn(false, animated: true)
                self?.showOpenSettingsAlert()
            })
        case false:
            userDefaultsManager.showNotifications = false
            notificationManager.unregisterForRemoteNotifications()
        }
    }

    private func showOpenSettingsAlert() {
        let alertController = UIAlertController (title: L10n.error, message: L10n.disabledNotificationAlertBody, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: L10n.cancel, style: .default, handler: nil)
        alertController.addAction(cancelAction)

        let settingsAction = UIAlertAction(title: L10n.settings, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension SettingsViewController {

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return notificationHeader.intrinsicContentSize.height
        case 1: return supportHeader.intrinsicContentSize.height
        case 2: return 24.0
        default: fatalError("Unknown section in \(description)")
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return notificationHeader
        case 1: return supportHeader
        case 2: return nil
        default: fatalError("Unknown section in \(description)")
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0: return nil
        case 1: return supportFooter
        case 2: return nil
        default: fatalError("Unknown section in \(description)")
        }
    }

}

// MARK: - Temporary method while testing
extension SettingsViewController {
    private func showDisabledReviewAlert() {
        let alertTitle = "Oops"
        let alertBody = "Thank you, but reviews will not be possible until Adequate is released on the App Store."

        let alertController = UIAlertController(title: alertTitle, message: alertBody, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)

        present(alertController, animated: true, completion: nil)
    }
}

/*
// MARK: - Themeable
extension SettingsViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        notificationCell.backgroundColor = theme.accentColor
        webCell.backgroundColor = theme.accentColor
        emailCell.backgroundColor = theme.accentColor
        twitterCell.backgroundColor = theme.accentColor
        aboutCell.backgroundColor = theme.accentColor
        reviewCell.backgroundColor = theme.accentColor

        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        notificationSwitch.onTintColor = theme.backgroundColor

        // foreground
        notificationCell.textLabel?.textColor = theme.backgroundColor
        notificationCell.detailTextLabel?.textColor = theme.backgroundColor.withAlphaComponent(0.5)
        webCell.textLabel?.textColor = theme.backgroundColor
        webCell.detailTextLabel?.textColor = theme.backgroundColor.withAlphaComponent(0.5)
        emailCell.textLabel?.textColor = theme.backgroundColor
        emailCell.detailTextLabel?.textColor = theme.backgroundColor.withAlphaComponent(0.5)
        twitterCell.textLabel?.textColor = theme.backgroundColor
        twitterCell.detailTextLabel?.textColor = theme.backgroundColor.withAlphaComponent(0.5)
        aboutCell.textLabel?.textColor = theme.backgroundColor
        reviewCell.textLabel?.textColor = theme.backgroundColor

        notificationHeader.textColor = theme.foreground.textColor.withAlphaComponent(0.5)
        supportHeader.textColor = theme.foreground.textColor.withAlphaComponent(0.5)
        supportFooter.textColor = theme.foreground.textColor.withAlphaComponent(0.5)
    }
}
*/
// MARK: - Config
extension SettingsViewController {
    enum SupportAddress: String {
        case web = "example.com"
        case email = "app@mgacy.com"
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
}
