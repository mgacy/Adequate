//
//  SettingsViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/26/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// swiftlint:disable file_length

// MARK: - Delegate Protocol

protocol SettingsViewControllerDelegate: VoidDismissalDelegate {
    func showAppIcon()
    func showTheme()
    func showAbout()
    func showReview()
}

// MARK: - View

final class SettingsViewController: UITableViewController {
    typealias Dependencies = HasUserDefaultsManager & HasThemeManager & NotificationManagerProvider

    weak var delegate: SettingsViewControllerDelegate?
    private let notificationManager: NotificationManagerType
    private let themeManager: ThemeManagerType
    private let userDefaultsManager: UserDefaultsManagerType
    //private var observationTokens: [ObservationToken] = []

    private var mailComposer: MailComposer?

    // MARK: - Subviews

    // TODO: check `UIApplication.shared.supportsAlternateIcons` before displaying `appIconCell`?
    // TODO: add cell with switch to enable / disable sound for notification (see Drafts.app)

    private lazy var notificationCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = L10n.dailyNotifications
        cell.selectionStyle = .none
        cell.accessoryView = notificationSwitch
        notificationSwitch.addTarget(self, action: #selector(tappedSwitch(_:)), for: .touchUpInside)
        return cell
    }()

    private let notificationSwitch: UISwitch = {
        let view = UISwitch()
        return view
    }()

    private lazy var themeCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.theme
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }()

    private lazy var appIconCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.appIcon
        cell.accessoryType = .disclosureIndicator
        return cell
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

    private lazy var appVersion: String = {
        let versionNumber = Bundle.main.releaseVersionNumber ?? "X"
        let buildNumber = Bundle.main.buildVersionNumber ?? "X"
        return "Adequate v\(versionNumber) (\(buildNumber))"
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.notificationManager = dependencies.makeNotificationManager()
        self.themeManager = dependencies.themeManager
        self.userDefaultsManager = dependencies.userDefaultsManager
        super.init(style: .insetGrouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        title = L10n.settings
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                            action: #selector(didPressDone(_:)))

        //apply(theme: themeManager.theme)
        if let interfaceStyle = themeManager.theme.foreground?.userInterfaceStyle {
            navigationController?.overrideUserInterfaceStyle = interfaceStyle
            updateThemeCell(for: interfaceStyle)
        }

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

    // MARK: - Actions

    @objc private func didPressDone(_ sender: UIBarButtonItem) {
        delegate?.dismiss()
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
        let alertController = UIAlertController(title: L10n.error, message: L10n.disabledNotificationAlertBody,
                                                preferredStyle: .alert)

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

// MARK: - Change Theme
extension SettingsViewController {

    private func showChangeThemeAlert() {
        let alertController = makeColorPaletteAlertController { [weak self] style in
            self?.navigationController?.overrideUserInterfaceStyle = style
            self?.updateThemeCell(for: style)
            self?.userDefaultsManager.interfaceStyle = style
            self?.themeManager.applyUserInterfaceStyle(style)
        }
        self.present(alertController, animated: true)
    }

    private func makeColorPaletteAlertController(actionHandler: @escaping (UIUserInterfaceStyle) -> Void) -> UIAlertController {
        let systemAction = UIAlertAction(title: L10n.themeSystem, style: .default) { _ in
            actionHandler(.unspecified)
        }
        let lightAction = UIAlertAction(title: L10n.themeLight, style: .default) { _ in
            actionHandler(.light)
        }
        let darkAction = UIAlertAction(title: L10n.themeDark, style: .default) { _ in
            actionHandler(.dark)
        }
        let cancelAction = UIAlertAction(title: L10n.cancel, style: .cancel)

        let alert = UIAlertController(title: L10n.theme,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(systemAction)
        alert.addAction(lightAction)
        alert.addAction(darkAction)
        alert.addAction(cancelAction)
        return alert
    }

    func updateThemeCell(for interfaceStyle: UIUserInterfaceStyle) {
        switch interfaceStyle {
        case .dark:
            themeCell.detailTextLabel?.text = L10n.themeDark
        case .light:
            themeCell.detailTextLabel?.text = L10n.themeLight
        case .unspecified:
            themeCell.detailTextLabel?.text = L10n.themeSystem
        @unknown default:
            log.error("Unrecognized UIUserInterfaceStyle: \(interfaceStyle)")
        }
    }
}

// MARK: - Email Support
extension SettingsViewController {

    private func logData(atPath path: String) -> Data? {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectoryPath = arrayPaths[0]
        let logPath = cacheDirectoryPath.appendingPathComponent(path)
        return FileManager.default.contents(atPath: logPath.path)
    }

    private func showSupportEmail() {
        var attachments: [MailComposer.MailAttachment]?
        if let logData = logData(atPath: UserSupportFile.log) {
            attachments = [MailComposer.MailAttachment(data: logData,
                                                       mimeType: .text,
                                                       fileName: UserSupportFile.log)
            ]
        }

        let composer = MailComposer()
        guard let mailController = composer.configuredMailComposeViewController(
            recipients: [SupportAddress.email.rawValue],
            subject: SupportEmailMessage.subject,
            message: SupportEmailMessage.message,
            attachments: attachments,
            completionHandler: { [weak self] result in
                if case .failure(let error) = result {
                    log.error("\(error.localizedDescription)")
                }
                self?.mailComposer = nil
            }
        ) else {
            displayError(message: L10n.disabledEmailAlertBody)
            return
        }
        mailComposer = composer
        present(mailController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 3
        case 3: return 2
        default: fatalError("Unknown number of sections in \(description)")
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return notificationCell
            default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
            }
        case 1:
            switch indexPath.row {
            // TODO: appIconCell first?
            case 0: return themeCell
            case 1: return appIconCell
            default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
            }
        case 2:
            switch indexPath.row {
            case 0: return webCell
            case 1: return emailCell
            case 2: return twitterCell
            default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
            }
        case 3:
            switch indexPath.row {
            case 0: return aboutCell
            case 1: return reviewCell
            default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
            }
        default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return L10n.notifications.uppercased()
        case 1: return L10n.appearance.uppercased()
        case 2: return L10n.support.uppercased()
        case 3: return nil
        default: fatalError("Unknown section in \(description)")
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return nil
        case 2: return L10n.unofficialAppDisclaimer
        case 3: return appVersion
        default: fatalError("Unknown section in \(description)")
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController {

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: defer {}?
        tableView.deselectRow(at: indexPath, animated: false)

        let application = UIApplication.shared
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            if UIDevice.current.userInterfaceIdiom == .pad {
                delegate?.showTheme()
            } else {
                showChangeThemeAlert()
            }
        case (1, 1):
            guard UIApplication.shared.supportsAlternateIcons else {
                displayError(message: L10n.disabledIconChangeAlertBody)
                return
            }
            delegate?.showAppIcon()
        case (2, 0):
            guard let webURL = URL(string: "https://\(SupportAddress.web.rawValue)") else {
                log.error("Bad web support address")
                return
            }
            application.open(webURL)
        case (2, 1):
            showSupportEmail()
        case (2, 2):
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
        case (3, 0):
            delegate?.showAbout()
        case (3, 1):
            switch Configuration.environment {
            case .development:
                showDisabledReviewAlert()
            case .staging:
                showDisabledReviewAlert()
            case .production:
                delegate?.showReview()
            }
        default:
            return
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

    func apply(theme: ColorTheme) {
        notificationHeader.textColor = theme.secondaryLabel
        supportHeader.textColor = theme.secondaryLabel
        supportFooter.textColor = theme.secondaryLabel
        // FIXME: finish
    }
}
*/
// MARK: - Config
extension SettingsViewController {
    enum SupportAddress: String {
        case web = "mgacy.github.io/Adequate"
        case email = "app@mgacy.com"
        case twitter = "@AdequateApp"

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

    enum SupportEmailMessage {
        static let subject: String = "Support Request: Adequate"

        static var message: String {
            var message = """

            --
            Support is only available in English.

            \(UIDevice.current.modelIdentifier)
            \(UIDevice.current.systemVersion)
            """

            if
                let versionNumber = Bundle.main.releaseVersionNumber,
                let buildNumber = Bundle.main.buildVersionNumber
            {
                message += "\n\(versionNumber) (\(buildNumber))"
            }

            if let identifier = UIDevice.current.identifierForVendor {
                message += "\n\(identifier)"
            }
            return message
        }
    }

    enum UserSupportFile {
        static let log: String = "swiftybeaver.log"
    }
}
