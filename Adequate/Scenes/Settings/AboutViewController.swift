//
//  AboutViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/30/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol

protocol AboutViewControllerDelegate: AnyObject {
    func showAcknowledgements()
    func showPrivacyPolicy()
}

// MARK: - View

final class AboutViewController: UITableViewController {
    //typealias Dependencies = HasThemeManager

    weak var delegate: AboutViewControllerDelegate? = nil
    //private let themeManager: ThemeManagerType
    //private var observationTokens: [ObservationToken] = []

    // MARK: - Subviews

    private lazy var versionCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        return cell
    }()

    private lazy var privacyPolicyCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.privacyPolicy
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    private lazy var acknowledgementsCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.acknowledgements
        cell.accessoryType = .disclosureIndicator
        return cell
    }()

    // MARK: - Lifecycle

    init() {
        //self.themeManager = dependencies.themeManager
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        //apply(theme: themeManager.theme)
        let versionNumber = Bundle.main.releaseVersionNumber ?? "X"
        let buildNumber = Bundle.main.buildVersionNumber ?? "X"
        versionCell.textLabel?.text = "v\(versionNumber) (\(buildNumber))"
    }
    /*
    private func setupObservations() -> [ObservationToken] {
        let themeToken = themeManager.addObserver(self)
        return [themeToken]
    }
    */
    // MARK: - UITableViewDatasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        default: fatalError("Unknown number of sections in \(description)")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return versionCell
            case 1: return privacyPolicyCell
            case 2: return acknowledgementsCell
            default: fatalError("Unknown row in section 0 of \(description)")
            }
        default: fatalError("Unknown section in \(description)")
        }
    }

    // MARK: - UITableViewDelegate

    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return
        case (0,1):
            delegate?.showPrivacyPolicy()
        case (0,2):
            delegate?.showAcknowledgements()
        default:
            return
        }
    }

}
/*
// MARK: - Themeable
extension AboutViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        versionCell.backgroundColor = theme.accentColor
        privacyPolicyCell.backgroundColor = theme.accentColor
        acknowledgementsCell.backgroundColor = theme.accentColor

        // backgroundColor
        view.backgroundColor = theme.backgroundColor

        // foreground
        versionCell.textLabel?.textColor = theme.backgroundColor
        versionCell.detailTextLabel?.textColor = theme.backgroundColor.withAlphaComponent(0.5)
        privacyPolicyCell.textLabel?.textColor = theme.backgroundColor
        privacyPolicyCell.detailTextLabel?.textColor = theme.backgroundColor.withAlphaComponent(0.5)
        acknowledgementsCell.textLabel?.textColor = theme.backgroundColor
        acknowledgementsCell.detailTextLabel?.textColor = theme.backgroundColor.withAlphaComponent(0.5)
    }

    func apply(theme: ColorTheme) {
        // ...
    }
}
*/

// MARK: - Bundle Extensions
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        //let bundleVersionKey = kCFBundleVersionKey as String
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}
