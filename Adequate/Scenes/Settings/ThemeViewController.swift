//
//  ThemeViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

final class ThemeViewController: UITableViewController {
    typealias Dependencies = HasUserDefaultsManager & HasThemeManager

    private let themeManager: ThemeManagerType
    private let userDefaultsManager: UserDefaultsManagerType

    // MARK: - Subviews

    private lazy var systemCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.themeSystem
        return cell
    }()

    private lazy var lightCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.themeLight
        return cell
    }()

    private lazy var darkCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = L10n.themeDark
        return cell
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
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

    // MARK: - View Methods

    func setupView() {
        title = L10n.theme
        updateActiveThemeCell(for: userDefaultsManager.interfaceStyle)
    }

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
            case 0: return systemCell
            case 1: return lightCell
            case 2: return darkCell
            default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
            }
        default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            updateActiveThemeCell(for: .unspecified)
            applyUserInterfaceStyle(.unspecified)
            return
        case (0, 1):
            updateActiveThemeCell(for: .light)
            applyUserInterfaceStyle(.light)
            return
        case (0, 2):
            updateActiveThemeCell(for: .dark)
            applyUserInterfaceStyle(.dark)
            return
        default:
            return
        }
    }
}

extension ThemeViewController {

    private func applyUserInterfaceStyle(_ interfaceStyle: UIUserInterfaceStyle) {
        self.navigationController?.overrideUserInterfaceStyle = interfaceStyle
        userDefaultsManager.interfaceStyle = interfaceStyle
        self.themeManager.applyUserInterfaceStyle(interfaceStyle)
    }

    private func updateActiveThemeCell(for interfaceStyle: UIUserInterfaceStyle) {
        switch interfaceStyle {
        case .dark:
            systemCell.accessoryType = .none
            lightCell.accessoryType = .none
            darkCell.accessoryType = .checkmark
        case .light:
            systemCell.accessoryType = .none
            lightCell.accessoryType = .checkmark
            darkCell.accessoryType = .none
        case .unspecified:
            systemCell.accessoryType = .checkmark
            lightCell.accessoryType = .none
            darkCell.accessoryType = .none
        @unknown default:
            fatalError("Unrecognized UIUserInterfaceStyle: \(interfaceStyle)")
        }
    }
}
