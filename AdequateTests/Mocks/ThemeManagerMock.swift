//
//  ThemeManagerMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation
@testable import Adequate

class ThemeManagerMock: ThemeManagerType {
    var useDealTheme: Bool = false

    var theme: AppTheme {
        didSet {
            callObservations(with: theme)
        }
    }

    init(theme: AppTheme = .system) {
        self.theme = theme
    }

    // MARK: - Observation

    private var observations: [UUID: (AppTheme) -> Void] = [:]

    func addObserver<T: AnyObject & ThemeObserving>(_ observer: T) -> ObservationToken {
        let id = UUID()
        observations[id] = { [weak self, weak observer] theme in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.removeValue(forKey: id)
                return
            }
            observer.apply(theme: theme)
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
