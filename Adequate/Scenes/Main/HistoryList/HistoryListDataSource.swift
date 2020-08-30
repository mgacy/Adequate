//
//  HistoryListDataSource.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class HistoryListDataSource: NSObject {
    typealias Dependencies = HasDataProvider
    typealias Deal = DealHistoryQuery.Data.DealHistory.Item
    typealias ResultType = TableViewDiff

    // MARK: - Properties

    var isEmpty: Bool {
        return deals.isEmpty
    }

    private let dataProvider: DataProviderType
    private var deals: [Deal] = []

    private var observationTokens: [ObservationToken] = []
    private(set) var state: ViewState<ResultType> {
        didSet {
            callObservations(with: state)
        }
    }

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.dataProvider = dependencies.dataProvider
        self.state = .empty
        super.init()
        observationTokens = setupObservations()
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - Additional

    func getDealHistory() {
        dataProvider.getDealHistory()
    }

    func objectAtIndexPath(_ indexPath: IndexPath) -> Deal {
        return deals[indexPath.row]
    }

    // MARK: - Observations

    private func setupObservations() -> [ObservationToken] {
        let historyToken = dataProvider.addHistoryObserver(self) { ds, viewState in
            switch viewState {
            case .result(let newDeals):
                // TODO: skip diff on initial load?
                var deletedIndexPaths = [IndexPath]()
                var insertedIndexPaths = [IndexPath]()
                let diff = newDeals.difference(from: ds.deals)

                for change in diff {
                    switch change {
                    case let .remove(offset, _, _):
                        deletedIndexPaths.append(IndexPath(row: offset, section: 0))
                    case let .insert(offset, _, _):
                        insertedIndexPaths.append(IndexPath(row: offset, section: 0))
                    }
                }
                let result = TableViewDiff(deletedIndexPaths: deletedIndexPaths,
                                           insertedIndexPaths: insertedIndexPaths)

                ds.deals = newDeals
                ds.state = viewState.map { _ in return result }
            case .empty:
                ds.deals = []
                ds.state = .empty
            case .loading:
                ds.state = .loading
            case .error(let error):
                // TODO: what about ds.deals?
                ds.state = .error(error)
            }
        }
        return [historyToken]
    }

    // MARK: - Observable

    private var observations: [UUID: (ViewState<ResultType>) -> Void] = [:]

    func addObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, ViewState<ResultType>) -> Void) -> ObservationToken {
        let id = UUID()
        observations[id] = { [weak self, weak observer] state in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.removeValue(forKey: id)
                return
            }
            closure(observer, state)
        }

        closure(observer, state)
        return ObservationToken { [weak self] in
            self?.observations.removeValue(forKey: id)
        }
    }

    private func callObservations(with state: ViewState<ResultType>) {
        observations.values.forEach { observation in
            observation(state)
        }
    }

}

// MARK: - UITableViewDataSouce
extension HistoryListDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deal = objectAtIndexPath(indexPath)
        let cell: HistoryListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: deal)
        return cell
    }

}
