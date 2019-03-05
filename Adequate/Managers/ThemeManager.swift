//
//  ThemeManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/23/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol ThemeManagerType {
    var theme: AppTheme { get }
    func applyTheme(theme: Theme) -> AppTheme
}

// MARK: - Implementation
class ThemeManager: ThemeManagerType {

    var theme: AppTheme

    init(theme: Theme) {
        self.theme = AppTheme(theme: theme)
    }

    func applyTheme(theme: Theme) -> AppTheme {
        let appTheme = AppTheme(theme: theme)
        self.theme = AppTheme(theme: theme)

        UIApplication.shared.delegate?.window??.tintColor = appTheme.accentColor
        UINavigationBar.appearance().barTintColor = appTheme.backgroundColor

        // status bar
        // https://stackoverflow.com/a/47749921/4472195

        // home indicator
        // https://stackoverflow.com/questions/46194557/how-to-change-home-indicator-background-color-on-iphone-x

        return appTheme
    }

}
