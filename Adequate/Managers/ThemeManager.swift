//
//  ThemeManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/23/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Combine

// MARK: - Protocol
protocol ThemeManagerType {
    var useDealTheme: Bool { get }
    var theme: AppTheme { get }
    // https://swiftsenpai.com/swift/define-protocol-with-published-property-wrapper/
    var themePublisher: Published<AppTheme>.Publisher { get }
    func applyUserInterfaceStyle(_ style: UIUserInterfaceStyle)
}

// MARK: - Implementation
class ThemeManager: ThemeManagerType {

    private static var animationDuration: TimeInterval = 0.3

    private let dataProvider: DataProviderType
    private var dealObservationToken: ObservationToken?

    private(set) var useDealTheme: Bool = false
    @Published private(set) var theme: AppTheme

    // Manually expose name publisher in view model implementation
    var themePublisher: Published<AppTheme>.Publisher { $theme }

    init(dataProvider: DataProviderType, theme: AppTheme) {
        self.dataProvider = dataProvider
        self.theme = theme
        if useDealTheme {
            dealObservationToken = startDealObservation()
        }
    }

    func applyTheme(theme: Theme) {
        let newTheme = AppTheme(baseTheme: self.theme.baseTheme,
                                dealTheme: ColorTheme(theme: theme),
                                foreground: theme.foreground)
        self.theme = newTheme

        //UIApplication.shared.delegate?.window??.tintColor = appTheme.accentColor
        //UINavigationBar.appearance().barTintColor = appTheme.backgroundColor

        // status bar
        // https://stackoverflow.com/a/47749921/4472195

        // home indicator
        // https://stackoverflow.com/questions/46194557/how-to-change-home-indicator-background-color-on-iphone-x
    }

    func applyUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        let themeForeground = ThemeForeground(userInterfaceStyle: style)
        let updatedTheme = AppTheme.lens.foreground.set(themeForeground)(theme)
        theme = updatedTheme
    }
}

// MARK: - DataProvider Observation
extension ThemeManager {

    func startDealObservation () -> ObservationToken {
        guard dealObservationToken == nil else {
            stopDealObservation()
            return startDealObservation()
        }
        return dataProvider.addDealObserver(self) { themeManager, dealState in
            guard case .result(let deal) = dealState else {
                return
            }
            themeManager.applyTheme(theme: deal.theme)
        }
    }

    func stopDealObservation() {
        guard let token = dealObservationToken else {
            return
        }
        token.cancel()
        dealObservationToken = nil
    }
}
