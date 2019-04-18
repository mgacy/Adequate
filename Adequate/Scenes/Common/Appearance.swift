//
//  Appearance.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/30/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

public struct Appearance {

    static var stylesheet = """
    * { font: -apple-system-body; }
    h1, h2, h3, h4, h5, h6, strong { font-weight: bold; }
    em { font-style: italic; }
    h1 { font-size: 175%; }
    h2 { font-size: 150%; }
    h3 { font-size: 130%; }
    h4 { font-size: 115%; }
    h5 { font-style: italic; }
    """

    private init() {}
}

// MARK: - ColorPalette

public struct ColorPalette {

    // FullscreenImageViewController
    // closeButton
    public static let darkGray = UIColor(red: 0.207, green: 0.207, blue: 0.207, alpha: 1.0)

    private init() {}
}
