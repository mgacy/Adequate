//
//  FullScreenImagePresenting.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/28/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

/// View controller delegate protocol to present FullScreenImageViewController
protocol FullScreenImagePresenting {
    func showImage(animatingFrom: ViewAnimatedTransitioning, dataSource: PagedImageViewDataSourceType, indexPath: IndexPath)
}

// MARK: - Coordinator + FullScreenImagePresenting
extension FullScreenImagePresenting where Self: Coordinator, Self: FullScreenImageDelegate {

    func showImage(animatingFrom fromDelegate: ViewAnimatedTransitioning, dataSource: PagedImageViewDataSourceType, indexPath: IndexPath) {
        let viewController = FullScreenImageViewController(dataSource: dataSource, indexPath: indexPath)
        viewController.delegate = self
        viewController.setupTransitionController(animatingFrom: fromDelegate)
        router.present(viewController, animated: true)
    }
}
