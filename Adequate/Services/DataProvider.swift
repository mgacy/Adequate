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
    func getDealHistory(from: Date, to: Date)
    func addDealObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<Deal>) -> Void) -> ObservationToken
    func addHistoryObserver<T: AnyObject>(_: T, closure: @escaping (T, ViewState<[Deal]>) -> Void) -> ObservationToken
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

    private var historyState: ViewState<[Deal]> {
        didSet {
            callObservations(with: historyState)
        }
    }

    private let mehService: MehServiceType
    private var dealObservations: [UUID: (ViewState<Deal>) -> Void] = [:]
    private var historyObservations: [UUID: (ViewState<[Deal]>) -> Void] = [:]

    // MARK: - Lifecycle

    init(mehService: MehServiceType) {
        self.mehService = mehService
        self.dealState = .empty
        self.historyState = .empty
    }

    // MARK: - A

    func getDeal() {
        guard dealState != ViewState<Deal>.loading else { return }
        dealState = .loading
        mehService.getDeal().then({ response in
            self.dealState = .result(response.deal)
        }).catch({ error in
            self.dealState = .error(error)
        })
    }

    func getDealHistory(from startDate: Date, to endDate: Date) {
        guard historyState != ViewState<[Deal]>.loading else { return }
        historyState = .loading
        mehService.getDeal().then({ response in
            self.historyState = .result([response.deal, response.deal, response.deal, response.deal])
        }).catch({ error in
            self.historyState = .error(error)
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

    func addHistoryObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, ViewState<[Deal]>) -> Void) -> ObservationToken {
        let id = UUID()
        historyObservations[id] = { [weak self, weak observer] state in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.historyObservations.removeValue(forKey: id)
                return
            }
            closure(observer, state)
        }

        closure(observer, historyState)
        return ObservationToken { [weak self] in
            self?.historyObservations.removeValue(forKey: id)
        }
    }

    private func callObservations(with dealState: ViewState<Deal>) {
        dealObservations.values.forEach { observation in
            observation(dealState)
        }
    }

    private func callObservations(with dealState: ViewState<[Deal]>) {
        historyObservations.values.forEach { observation in
            observation(dealState)
        }
    }

}
