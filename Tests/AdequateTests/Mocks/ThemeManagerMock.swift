//
//  ThemeManagerMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit
import Foundation
@testable import Adequate

class ThemeManagerMock: ThemeManagerType {
    var useDealTheme: Bool = false

    @Published private(set) var theme: AppTheme

    // Manually expose name publisher in view model implementation
    var themePublisher: Published<AppTheme>.Publisher { $theme }

    init(theme: AppTheme = .system) {
        self.theme = theme
    }

    func applyUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        // ...
    }
}
