//
//  ZoomAnimator.swift
//  Adequate
//
//  Created by Mathew Gacy on 5/1/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

class ZoomAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let transitionDuration: TimeInterval = 0.3
    let fromDelegate: ViewAnimatedTransitioning
    let toDelegate: ViewAnimatedTransitioning

    init(from fromDelegate: ViewAnimatedTransitioning, to toDelegate: ViewAnimatedTransitioning) {
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Override in subclass.")
    }
}

// MARK: - Factories
extension ZoomAnimator {

    func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator {
        //let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let springTiming = UISpringTimingParameters(dampingRatio: 0.7)

        let duration = transitionDuration(using: transitionContext)
        return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
    }

    func makeTransitioningView() -> UIView {
        // TODO: complete
        let view = UIView()
        view.backgroundColor = ColorCompatibility.secondarySystemBackground
        // Use `photo` symbol?
        return view
    }
}
