//
//  AppTheme.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/24/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

struct AppTheme: Equatable {

    enum CornerRadius: CGFloat {
        case small = 5.0
    }

    // Basic Layout
    static let spacing: CGFloat = 8.0
    static let sideMargin: CGFloat = 16.0
    static let widthInset: CGFloat = -32.0

    // Meh
    let baseTheme: ColorTheme
    let dealTheme: ColorTheme?
    let foreground: ThemeForeground?
}

// MARK: - Initializers
extension AppTheme {

}

// MARK: - Default
extension AppTheme {
    static var system: AppTheme {
        return AppTheme(baseTheme: ColorTheme.system,
                        dealTheme: nil,
                        foreground: .unknown("system"))
    }
}
