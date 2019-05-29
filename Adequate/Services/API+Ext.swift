//
//  API+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

extension ThemeForeground: Codable {

    var textColor: UIColor {
        switch self {
        case .dark: return .black
        case .light: return .white
        case .unknown: return .yellow
        }
    }

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark: return .default
        case .light: return .lightContent
        case .unknown: return .default
        }
    }

    var navigationBarStyle: UIBarStyle {
        switch self {
        case .dark: return .default
        case .light: return .black
        case .unknown: return .default
        }
    }

}

extension ListDealsForPeriodQuery.Data.ListDealsForPeriod.Theme: ThemeType {}
