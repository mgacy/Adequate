//
//  DataProvider.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/28/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Promise

// MARK: - Protocol

protocol DataProviderType {
    func getDeal()
    func addDealObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<Deal>) -> Void) -> ObservationToken
}

// MARK: - Implementation

class DataProvider: DataProviderType {

    // TODO: rename `ViewState<T>` as `ResourceState<T>`?
    private var dealState: ViewState<Deal> {
        didSet {
            // TODO: check that viewState != oldValue before calling completions?
            callObservations(with: dealState)
        }
    }

    private let mehService: MehServiceType
    private var dealObservations: [UUID: (ViewState<Deal>) -> Void] = [:]

    // MARK: - Lifecycle

    init(mehService: MehServiceType) {
        self.mehService = mehService
        self.dealState = .empty
    }

    // MARK: - A

    func getDeal() {
        // TODO: check dealState != .loading
        dealState = .loading
        mehService.getDeal().then({ response in
            self.dealState = .result(response.deal)
        }).catch({ error in
            self.dealState = .error(error)
        })
    }

    // MARK: - Observers

    @discardableResult
    func addDealObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, ViewState<Deal>) -> Void) -> ObservationToken {
        let id = UUID()
        dealObservations[id] = { [weak self, weak observer] state in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.dealObservations.removeValue(forKey: id)
                return
            }
            closure(observer, state)
        }

        closure(observer, dealState)
        return ObservationToken { [weak self] in
            self?.dealObservations.removeValue(forKey: id)
        }
    }

    private func callObservations(with dealState: ViewState<Deal>) {
        dealObservations.values.forEach { observation in
            observation(dealState)
        }
    }

}
