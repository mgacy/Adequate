//
//  AppTheme.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/24/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

struct AppTheme {
    /*
    // Basic Layout
    let spacing: CGFloat = 8.0
    let sideMargin: CGFloat = 16.0
    let widthInset: CGFloat = -32.0
    */
    // Meh
    let accentColor: UIColor
    let backgroundColor: UIColor
    let foreground: ThemeForeground

    init(theme: Theme) {
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
