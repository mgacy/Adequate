//
//  ZoomInAnimationController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class ZoomInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

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
        guard
            //let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        // TODO: call transitionAnimationWillStart() method on delegates
        // TODO: is fromVC displaying image / activityIndicator (/ error?)

        toDelegate.originView.isHidden = true
        toVC.view.alpha = 0.0
        containerView.addSubview(toVC.view)
        toVC.view.frame = finalFrame

        // transitionView
        let transitionView = fromDelegate.makeTransitioningView() ?? makeTransitioningView()
        containerView.addSubview(transitionView)
        transitionView.frame = fromDelegate.originFrame
        fromDelegate.originView.isHidden = true

        // Animation
        let animation = { () -> Void in
            transitionView.frame = self.toDelegate.originFrame
            toVC.view.alpha = 1.0
        }

        // Completion
        let completion = { (finished: Bool) -> Void in
            // TODO: call `transitionAnimationDidEnd()` method on delegates
            self.toDelegate.originView.isHidden = false
            transitionView.removeFromSuperview()

            //if !finished {
            //    fromDelegate.originView.isHidden = false
            //}

            if transitionContext.isInteractive {
                if transitionContext.transitionWasCancelled {
                    transitionContext.cancelInteractiveTransition()
                } else {
                    transitionContext.finishInteractiveTransition()
                }
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        // Execute Animations
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [.curveEaseIn],
                       animations: animation,
                       completion: completion)
    }
}

// MARK: - Factories
extension ZoomInAnimationController {

    func makeTransitioningView() -> UIView {
        // TODO: complete
        let view = UIView()
        view.backgroundColor = ColorCompatibility.secondarySystemBackground
        // Use `photo` symbol?
        return view
    }
}
