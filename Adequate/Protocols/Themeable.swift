//
//  Themeable.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

protocol Themeable {
    func apply(theme: ColorTheme)
}

protocol ThemeObserving {
    func apply(theme: AppTheme)
}

protocol ForegroundThemeable {
    func apply(foreground: ThemeForeground)
}

extension ForegroundThemeable where Self: UIViewController {
    func apply(foreground: ThemeForeground) {
        // TODO: set home indicator color?
        if let navigationController = navigationController {
            navigationController.overrideUserInterfaceStyle = foreground.userInterfaceStyle
        } else {
            overrideUserInterfaceStyle = foreground.userInterfaceStyle
        }
        setNeedsStatusBarAppearanceUpdate()
    }
}
