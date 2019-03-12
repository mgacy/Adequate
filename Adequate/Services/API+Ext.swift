//
//  API+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

extension ThemeForeground {

    var textColor: UIColor {
        switch self {
        case .dark: return .black
        case .light: return .white
        default: return .yellow
        }
    }

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark: return .default
        case .light: return .lightContent
        default: return .default
        }
    }

}
