//
//  SlideAnimationController.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/2/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class SlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    enum TransitionType {
        case presenting
        case dismissing
    }

    let transitionType: TransitionType

    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        switch transitionType {
        case .presenting:
            animatePresentation(from: fromVC, to: toVC, using: transitionContext)
        case .dismissing:
            animateDismissal(from: fromVC, to: toVC, using: transitionContext)
        }
    }

    // MARK: - Present / Dismiss

    private func animatePresentation(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let dy = containerView.frame.size.height
        let finalFrame = transitionContext.finalFrame(for: toVC)

        toVC.view.frame = finalFrame.offsetBy(dx: 0.0, dy: dy)
        containerView.addSubview(toVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIView.AnimationOptions.curveEaseOut ],
            animations: {
                toVC.view.frame = finalFrame
            },
            completion: { _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

    private func animateDismissal(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let dy = containerView.frame.size.height
        let initialFrame = fromVC.view.frame

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = initialFrame.offsetBy(dx: 0.0, dy: dy)
            },
            completion: { _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

}
