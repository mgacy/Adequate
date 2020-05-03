//
//  ZoomOutAnimator.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class ZoomOutAnimator: ZoomAnimator {

    // Return same animator for `animateTransition(using:)` and `interruptibleAnimator(using:)`
    var animatorForCurrentTransition: UIViewImplicitlyAnimating?

    //deinit { print("\(#function) - \(self.description)") }

    // MARK: - UIViewControllerAnimatedTransitioning

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animatorForCurrentSession = animatorForCurrentTransition {
            return animatorForCurrentSession
        }

        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!

        let containerView = transitionContext.containerView
        //let finalFrame = transitionContext.finalFrame(for: toVC)

        // TODO: call `transitionAnimationWillStart()` on delegates
        toDelegate.originView.isHidden = true // Is this necessary?

        // transitionView
        let transitionView = fromDelegate.makeTransitioningView() ?? makeTransitioningView()
        containerView.addSubview(transitionView)
        transitionView.frame = fromDelegate.originFrame
        fromDelegate.originView.isHidden = true

        // Animation
        let animator = transitionAnimator(using: transitionContext)
        animator.addAnimations {
            toVC.setNeedsStatusBarAppearanceUpdate() // Is this necessary?
            transitionView.frame = self.toDelegate.originFrame
            fromVC.view.alpha = 0.0
        }

        animator.addCompletion { position in
            // TODO: call `transitionAnimationDidEnd()` on delegates
            self.fromDelegate.originView.isHidden = false
            if !transitionContext.transitionWasCancelled {
                self.toDelegate.originView.isHidden = false
            }
            transitionView.removeFromSuperview()

            switch position {
            case .end:
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            default:
                transitionContext.cancelInteractiveTransition()
                transitionContext.completeTransition(false)
            }
        }

        animatorForCurrentTransition = animator
        return animator
    }

    func animationEnded(_ transitionCompleted: Bool) {
        animatorForCurrentTransition = nil
    }
}
