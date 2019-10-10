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
}

// MARK: - Initializers
extension AppTheme {

    init(theme: ThemeType) {
        accentColor = UIColor(hexString: theme.accentColor)
        backgroundColor = UIColor(hexString: theme.backgroundColor)
        foreground = theme.foreground
    }

    init(accentColor: UIColor, backgroundColor: UIColor, foreground: ThemeForeground) {
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.foreground = foreground
    }
}
