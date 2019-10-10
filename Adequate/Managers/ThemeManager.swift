//
//  ThemeManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/23/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol ThemeManagerType {
    var theme: AppTheme { get }
    func applyTheme(theme: Theme)
    func addObserver<T: AnyObject & Themeable>(_ observer: T) -> ObservationToken
}

// MARK: - Implementation
class ThemeManager: ThemeManagerType {
    private static var animationDuration: TimeInterval = 0.3

    var theme: AppTheme {
        didSet {
            callObservations(with: theme)
        }
    }

    init(theme: Theme) {
        self.theme = AppTheme(theme: theme)
    }

    init(theme: AppTheme) {
        self.theme = theme
    }

    func applyTheme(theme: Theme) {
        //let appTheme = AppTheme(theme: theme)
        self.theme = AppTheme(theme: theme)

        //UIApplication.shared.delegate?.window??.tintColor = appTheme.accentColor
        //UINavigationBar.appearance().barTintColor = appTheme.backgroundColor

        // status bar
        // https://stackoverflow.com/a/47749921/4472195

        // home indicator
        // https://stackoverflow.com/questions/46194557/how-to-change-home-indicator-background-color-on-iphone-x
    }

    // MARK: - Observation

    private var observations: [UUID: (AppTheme) -> Void] = [:]

    func addObserver<T: AnyObject & Themeable>(_ observer: T) -> ObservationToken {
        let id = UUID()
        observations[id] = { [weak self, weak observer] theme in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.removeValue(forKey: id)
                return
            }
            UIView.animate(withDuration: ThemeManager.animationDuration, animations: {
                observer.apply(theme: theme)
            })
        }

        observer.apply(theme: theme)

        return ObservationToken { [weak self] in
            self?.observations.removeValue(forKey: id)
        }
    }

    private func callObservations(with theme: AppTheme) {
        observations.values.forEach { observation in
            observation(theme)
        }
    }

}
