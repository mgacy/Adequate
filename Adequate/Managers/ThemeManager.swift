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
    func addObserver<T: AnyObject & Themeable>(_ observer: T) -> ObservationToken
}

// MARK: - Implementation
class ThemeManager: ThemeManagerType {

    private static var animationDuration: TimeInterval = 0.3

    private let dataProvider: DataProviderType
    private var dealObservationToken: ObservationToken?

    var theme: AppTheme {
        didSet {
            callObservations(with: theme)
        }
    }

    init(dataProvider: DataProviderType, theme: AppTheme) {
        self.dataProvider = dataProvider
        self.theme = theme
        dealObservationToken = startDealObservation()
    }

    func applyTheme(theme: Theme) {
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

// MARK: - DataProvider Observation
extension ThemeManager {

    func startDealObservation () -> ObservationToken {
        // TODO: is this the best way to handle this?
        guard dealObservationToken == nil else {
            stopDealObservation()
            return startDealObservation()
        }
        return dataProvider.addDealObserver(self) { tm, dealState in
            guard case .result(let deal) = dealState else {
                return
            }
            tm.theme = AppTheme(theme: deal.theme)
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
