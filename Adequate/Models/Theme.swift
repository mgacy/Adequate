//
//  Theme.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

struct Theme: Codable, Equatable, ThemeType {
    let accentColor: String
    let backgroundColor: String
    //let backgroundImage: URL?
    let foreground: ThemeForeground
}

// MARK: - Initializers
extension Theme {
    init(_ theme: ThemeType) {
        self.accentColor = theme.accentColor
        self.backgroundColor = theme.backgroundColor
        self.foreground = theme.foreground
    }
}
