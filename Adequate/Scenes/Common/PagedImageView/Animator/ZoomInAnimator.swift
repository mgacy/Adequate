//
//  ZoomInAnimator.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class ZoomInAnimator: ZoomAnimator {

    //deinit { print("\(#function) - \(self.description)") }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            //let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        // TODO: determine whether `fromVC` displaying image / activityIndicator / error and animate accordingly

        toDelegate?.originView.isHidden = true
        toVC.view.alpha = 0.0
        containerView.addSubview(toVC.view)
        toVC.view.frame = finalFrame
        toVC.view.layoutIfNeeded()

        // transitionView
        let transitionView = fromDelegate?.makeTransitioningView() ?? makeTransitioningView()
        containerView.addSubview(transitionView)
        transitionView.frame = fromDelegate?.originFrame ?? .zero
        fromDelegate?.originView.isHidden = true

        // Animation
        let animator = transitionAnimator(using: transitionContext)
        animator.addAnimations {
            transitionView.frame = self.toDelegate?.originFrame ?? .zero
            toVC.view.alpha = 1.0
        }

        animator.addCompletion { _ in
            self.toDelegate?.originView.isHidden = false
            transitionView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        animator.startAnimation()
    }
}
