//
//  AppIconViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

final class AppIconViewController: UITableViewController {

    private var appIcon: AppIcon {
        didSet {
            updateCurrentIcon(appIcon, from: oldValue)
        }
    }

    // MARK: - Subviews

    private lazy var defaultLightCell: UITableViewCell = {
        let cell = AppIconCell()
        cell.textLabel?.text = L10n.defaultIcon
        return cell
    }()

    private lazy var defaultDarkCell: UITableViewCell = {
        let cell = AppIconCell()
        cell.textLabel?.text = L10n.defaultDarkIcon
        return cell
    }()

    private lazy var altLightCell: UITableViewCell = {
        let cell = AppIconCell()
        cell.textLabel?.text = L10n.altLightIcon
        return cell
    }()

    private lazy var altDarkCell: UITableViewCell = {
        let cell = AppIconCell()
        cell.textLabel?.text = L10n.altDarkIcon
        return cell
    }()

    // MARK: - Lifecycle

    init() {
        self.appIcon = AppIcon(name: UIApplication.shared.alternateIconName)
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
        title = "App Icon"
        configureCell(defaultLightCell, withIcon: .defaultLight)
        configureCell(defaultDarkCell, withIcon: .defaultDark)
        configureCell(altLightCell, withIcon: .altLight)
        configureCell(altDarkCell, withIcon: .altDark)

        updateCurrentIcon(appIcon)
    }

    func configureCell(_ cell: UITableViewCell, withIcon icon: AppIcon) {
        guard
            let imagePath = Bundle.main.path(forResource: icon.resourceName, ofType: "png"),
            let iconImage = UIImage(contentsOfFile: imagePath)
        else {
            return
        }
        cell.imageView?.image = iconImage
    }
}

// MARK: - UITableViewDatasource
extension AppIconViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        default: fatalError("Unknown number of sections in \(description)")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return defaultLightCell
            case 1: return defaultDarkCell
            case 2: return altLightCell
            case 3: return altDarkCell
            default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
            }
        default: fatalError("Unknown IndexPath in \(description): \(indexPath)")
        }
    }
}

// MARK: - UITableViewDelegate
extension AppIconViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedIcon: AppIcon
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            selectedIcon = .defaultLight
        case (0, 1):
            selectedIcon = .defaultDark
        case (0, 2):
            selectedIcon = .altLight
        case (0, 3):
            selectedIcon = .altDark
        default:
            return
        }
        appIcon = selectedIcon
        UIApplication.shared.setAlternateIconName(selectedIcon.iconName) { maybeError in
            if let error = maybeError {
                log.error("Unable to change icon: \(error)")
            }
        }
    }
}

extension AppIconViewController {

    private func indexPathForAppIcon(_ appIcon: AppIcon) -> IndexPath {
        switch appIcon {
        case .defaultLight: return IndexPath(row: 0, section: 0)
        case .defaultDark: return IndexPath(row: 1, section: 0)
        case .altLight: return IndexPath(row: 2, section: 0)
        case .altDark: return IndexPath(row: 3, section: 0)
        }
    }

    private func updateCurrentIcon(_ icon: AppIcon, from previousIcon: AppIcon? = nil) {
        if let previousIcon = previousIcon {
            let previousCell = tableView(tableView, cellForRowAt: indexPathForAppIcon(previousIcon))
            previousCell.accessoryType = .none
        }
        let newCell = tableView(tableView, cellForRowAt: indexPathForAppIcon(icon))
        newCell.accessoryType = .checkmark
    }
}

// MARK: - Types
extension AppIconViewController {

    enum AppIcon: String {
        case defaultLight = "Primary"
        case defaultDark = "AppIcon-2"
        case altLight = "AppIcon-3"
        case altDark = "AppIcon-4"

        init(name: String? = "Primary") {
            if let name = name {
                self = AppIcon(rawValue: name) ?? .defaultLight
            } else {
                self = .defaultLight
            }
        }

        var iconName: String? {
            switch self {
            case .defaultLight:
                return nil
            default:
                return rawValue
            }
        }

        var resourceName: String {
            switch self {
            case .defaultLight: return "Icon-1@2x"
            case .defaultDark: return "Icon-2@2x"
            case .altLight: return "Icon-3@2x"
            case .altDark: return "Icon-4@2x"
            }
        }
    }
}
