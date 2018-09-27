//
//  Theme.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

enum ThemeForeground: String, Codable {
    case dark
    case light
}

struct Theme: Codable {
    let accentColor: String
    let backgroundColor: String
    let backgroundImage: URL
    //let foreground: String
    let foreground: ThemeForeground
}
