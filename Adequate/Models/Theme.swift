//
//  Theme.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

enum ThemeForeground: String, Codable {
    case dark
    case light

    var textColor: UIColor {
        switch self {
        case .dark: return .black
        case .light: return .white
        }
    }

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark: return .default
        case .light: return .lightContent
        }
    }
}

struct Theme: Codable {
    let accentColor: String
    let backgroundColor: String
    //let backgroundImage: URL?
    let foreground: ThemeForeground
}
