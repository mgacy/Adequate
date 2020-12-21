//
//  ThemeType.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/12/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

public protocol ThemeType {
    var accentColor: String { get }
    var backgroundColor: String { get }
    var foreground: ThemeForeground { get }
}
