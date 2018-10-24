//
//  AppTheme.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/24/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

struct AppTheme {
    let accentColor: UIColor
    let backgroundColor: UIColor
    let foreground: ThemeForeground

    init(theme: Theme) {
        accentColor = UIColor(hexString: theme.accentColor)
        backgroundColor = UIColor(hexString: theme.backgroundColor)
        foreground = theme.foreground
    }
}
