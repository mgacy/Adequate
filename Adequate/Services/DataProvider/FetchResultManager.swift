//
//  FetchResultManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 5/13/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import Combine
import AWSAppSync

//protocol FetchResultManaging {
//    var actionPublisher: AnyPublisher<Action, Never> { get }
//
//    func configure(with: Published<ViewState<Deal>>.Publisher)
//    func push(_ type: ResultActionType)
//}

final class FetchResultManager {
    private let dateProvider: () -> Date

    private let actionSubject = PassthroughSubject<Action, Never>()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }

    private var cancellable: AnyCancellable?

    private var resultAction: ResultAction?

    init(dateProvider: @escaping () -> Date = Date.init) {
        self.dateProvider = dateProvider
    }

    func configure(with publisher: Published<ViewState<Deal>>.Publisher) {
        cancellable = publisher
            //.dropFirst()
            .compactMap { $0.completion }
            .sink { [weak self] result in
                guard let handler = self?.resultAction else {
                    return
                }
                self?.resultAction = nil
                self?.perform(handler, for: result)
            }
    }

    func push(_ type: ResultActionType) {
        let newAction = ResultAction(date: dateProvider(), type: type)
        if let currentAction = resultAction {
            switch currentAction.type {
            case .fetchHistory:
                break
            case .silentNotification(_, let handler):
                // TODO: set timer to go ahead and call in 30ish seconds?
                let elapsed = newAction.date.timeIntervalSince(currentAction.date)
                if elapsed > .fetchResultTimeout {
                    log.warning("⏱️ Replacing expired action and calling completionHandler: "
                                + "\(currentAction) - \(elapsed)")
                } else {
                    log.warning("🅰️ Replacing unexpired action and calling completionHandler: "
                                + "\(currentAction) - \(elapsed)")
                    // TODO: should we call handler with .failed in this instance too?
                }
                handler(.failed)
            }
        }

        resultAction = newAction
    }

    private func perform(_ action: ResultAction, for result: ViewState<Deal>.Completion) {
        switch action.type {
        case .fetchHistory(let cachePolicy):
            switch result {
            case .empty:
                actionSubject.send(.fetchHistory(cachePolicy))
            case .error:
                push(action.type)
            case .result:
                actionSubject.send(.fetchHistory(cachePolicy))
            }
        case .silentNotification(let id, let handler):
            switch result {
            case .empty:
                handler(.noData)
            case .error:
                log.info("BACKGROUND_APP_REFRESH: failed")
                handler(.failed)
            case .result(let newDeal):
                guard newDeal.dealID == id else {
                    log.error("BACKGROUND_APP_REFRESH: failed - Waited on response - \(newDeal.dealID) - that did "
                                + "not match DealDelta: \(id)")
                    handler(.failed)
                    return
                }
                // TODO: go ahead and push .fetchHistory?
                log.info("BACKGROUND_APP_REFRESH: newData")
                handler(.newData)
            }
        }
    }
}

// MARK: - Types
extension FetchResultManager {

    // MARK: Input

    /// Additional action to take upon completion after fetching current `Deal`.
    enum ResultActionType {
        case fetchHistory(CachePolicy)
        case silentNotification(dealID: GraphQLID, handler: (UIBackgroundFetchResult) -> Void)
        //case multiple([ResultAction]) // ResultActionType or ResultAction?
    }

    /// Wrapper for `ResultActionType`.
    private struct ResultAction {
        let date: Date
        let type: ResultActionType

        init(date: Date, type: ResultActionType) {
            self.date = date
            self.type = type
        }
    }

    // MARK: Output

    public enum Action {
        case fetchHistory(CachePolicy)
    }
}

// MARK: - ViewState + Helpers
fileprivate extension ViewState {

    /// The possible results of `ViewState`.
    enum Completion {
        case empty
        case error(Error)
        case result(Element)
    }

    var completion: Completion? {
        switch self {
        case .empty: return .empty
        case .loading: return nil
        case let .result(element): return .result(element)
        case let .error(error): return .error(error)
        }
    }
}

// MARK: - Extensions
fileprivate extension TimeInterval {
    static var fetchResultTimeout: TimeInterval = 60
}
