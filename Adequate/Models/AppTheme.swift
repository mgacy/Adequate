//
//  AppTheme.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/24/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

struct AppTheme {

    enum CornerRadius: CGFloat {
        case small = 5.0
    }

    // Basic Layout
    static let spacing: CGFloat = 8.0
    static let sideMargin: CGFloat = 16.0
    static let widthInset: CGFloat = -32.0

    // Meh
    let accentColor: UIColor
    let backgroundColor: UIColor
    let foreground: ThemeForeground
    
    // MARK: - New
    let dealTheme: ColorTheme?
    let baseTheme: ColorTheme
}

// MARK: - Initializers
extension AppTheme {

    init(theme: ThemeType) {
        accentColor = UIColor(hexString: theme.accentColor)
        backgroundColor = UIColor(hexString: theme.backgroundColor)
        foreground = theme.foreground

        dealTheme = nil
        baseTheme = ColorTheme(theme: theme)
    }
}

// MARK: - Default
extension AppTheme {
    static var system: AppTheme {
        return AppTheme(accentColor: ColorCompatibility.systemBlue,
                        backgroundColor: ColorCompatibility.systemBackground,
                        foreground: .unknown("system"),
                        dealTheme: nil,
                        baseTheme: ColorTheme.system)
    }
}
