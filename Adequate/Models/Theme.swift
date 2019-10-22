//
//  Theme.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

struct Theme: Equatable {

    private enum CodingKeys: String, CodingKey {
        case accentColor
        case backgroundColor
        //case backgroundImage
        case foreground
    }

    // Inspired by: https://stackoverflow.com/a/50934846/
    private struct HexColor: Codable {
        let hexString: String

        var uiColor: UIColor {
            return UIColor(hexString: hexString)
        }

        init(uiColor: UIColor) {
            self.hexString = uiColor.hexDescription(true)
        }
    }

    let accentColor: UIColor
    let backgroundColor: UIColor
    //let backgroundImage: URL?
    let foreground: ThemeForeground
}

// MARK: - Initializers
extension Theme {
    init(_ theme: ThemeType) {
        self.accentColor = UIColor(hexString: theme.accentColor)
        self.backgroundColor = UIColor(hexString: theme.backgroundColor)
        self.foreground = theme.foreground
    }
}

// MARK: - Encodable
extension Theme: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HexColor(uiColor: accentColor), forKey: .accentColor)
        try container.encode(HexColor(uiColor: backgroundColor), forKey: .backgroundColor)
        try container.encode(foreground, forKey: .foreground)
    }
}

// MARK: - Decodable
extension Theme: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accentColor = try container.decode(HexColor.self, forKey: .accentColor).uiColor
        backgroundColor = try container.decode(HexColor.self, forKey: .backgroundColor).uiColor
        foreground = try container.decode(ThemeForeground.self, forKey: .foreground)
    }
}
