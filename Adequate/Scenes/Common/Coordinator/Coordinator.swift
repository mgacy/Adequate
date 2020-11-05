//
//  Coordinator.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class Coordinator: BaseCoordinator {
    let router: RouterType

    init(router: RouterType) {
        self.router = router
    }
}

// MARK: - Presentable
extension Coordinator: Presentable {
    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}

// MARK: - FinishableCoordinator
class FinishableCoordinator<ResultType>: Coordinator, FinishableCoordinatorType {

    /// Typealias which allows access to ResultType of the Coordinator by `CoordinatorName.CoordinationResult`.
    typealias CoordinationResult = ResultType

    typealias FinishHandler = (ResultType) -> Void

    var onFinishFlow: FinishHandler?

}

// MARK: - VoidDismissalDelegate
extension FinishableCoordinator: VoidDismissalDelegate where CoordinationResult == Void {}
