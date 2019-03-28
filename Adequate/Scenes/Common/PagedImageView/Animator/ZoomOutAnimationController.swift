//
//  ZoomOutAnimationController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class ZoomOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private let pagedImageView: PagedImageView
    private let sourceFrame: CGRect

    init(animatingTo pagedImageView: PagedImageView) {
        self.pagedImageView = pagedImageView
        self.sourceFrame = pagedImageView.originFrame
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /// TODO: cast fromVC as protocol to get access to properties
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? FullScreenImageViewController,
            let toVC = transitionContext.viewController(forKey: .to) else {
                fatalError("ERROR: failed to cast as correct view controllers for transition")
        }
        let containerView = transitionContext.containerView
        //let finalFrame = transitionContext.finalFrame(for: toVC)

        /// TODO: is fromVC displaying image / activityIndicator (/ error?)

        fromVC.view.isHidden = true

        // cover pagedImageView of DealViewController
        let destinationImageCoveringView = UIView(frame: sourceFrame)
        destinationImageCoveringView.backgroundColor = toVC.view.backgroundColor
        containerView.addSubview(destinationImageCoveringView)

        // background
        let bgView = UIView(frame: fromVC.view.frame)
        bgView.backgroundColor = fromVC.view.backgroundColor
        containerView.addSubview(bgView)

        // image
        let transitionImageView: UIView
        if let transitionImage = fromVC.imageSource.value {
            transitionImageView = UIImageView(image: transitionImage)
            transitionImageView.frame = fromVC.view.frame
            transitionImageView.contentMode = .scaleAspectFit
        } else {
            transitionImageView = UIView(frame: fromVC.view.frame)
            transitionImageView.backgroundColor = .red
            /// TODO: set a different destinationFrame?
        }
        containerView.addSubview(transitionImageView)

        // Animation
        let destinationFrame = sourceFrame
        let imageAnimation = { () -> Void in
            transitionImageView.frame = destinationFrame
            //transitionImageView.center = toVC.view.center
            bgView.alpha = 0.0
        }

        // Completion
        let imageCompletion = { (_ finished: Bool) -> Void in
            fromVC.view.isHidden = false
            transitionImageView.removeFromSuperview()
            bgView.removeFromSuperview()
            destinationImageCoveringView.removeFromSuperview()

            //if transitionContext.transitionWasCancelled {
            //    toVC.view.removeFromSuperview()
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

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       options: [UIView.AnimationOptions.curveEaseOut],
                       animations: imageAnimation,
                       completion: imageCompletion)
    }

}
