//
//  ZoomOutAnimationController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class ZoomOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private let transitionDuration: TimeInterval = 0.3
    private let pagedImageView: PagedImageView
    private var destinationFrame: CGRect {
        // Use computed property to fix error in split view on iPad, where the value of this property at initialization
        // is not the same as when it is accessed from `animateTransition(using:)`
        return pagedImageView.originFrame
    }

    init(animatingTo pagedImageView: PagedImageView) {
        self.pagedImageView = pagedImageView
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // TODO: cast fromVC as protocol to get access to properties
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? FullScreenImageViewController,
            let toVC = transitionContext.viewController(forKey: .to) else {
                log.error("Failed to cast as correct view controllers for transition")
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        //let finalFrame = transitionContext.finalFrame(for: toVC)

        // TODO: is fromVC displaying image / activityIndicator (/ error?)

        // hide pagedImageView of DealViewController
        //pagedImageView.beginTransition()

        // hide FullScreenViewController and replace with background view
        let bgView = UIView(frame: fromVC.view.frame)
        bgView.backgroundColor = fromVC.view.backgroundColor
        containerView.addSubview(bgView)
        fromVC.view.isHidden = true

        // image
        let transitionImageView: UIView
        if let transitionImage = fromVC.imageSource.value {
            transitionImageView = UIImageView(image: transitionImage)
            transitionImageView.contentMode = .scaleAspectFit
            transitionImageView.frame = fromVC.originFrame
        } else {
            transitionImageView = UIView(frame: fromVC.view.frame)
            transitionImageView.backgroundColor = .red
            // TODO: set a different destinationFrame?
        }
        containerView.addSubview(transitionImageView)

        // Animation
        let imageAnimation = { () -> Void in
            UIView.performWithoutAnimation {
                toVC.setNeedsStatusBarAppearanceUpdate()
            }
            transitionImageView.frame = self.destinationFrame
            bgView.alpha = 0.0
        }

        // Completion
        let imageCompletion = { (finished: Bool) -> Void in
            fromVC.view.isHidden = false
            if !transitionContext.transitionWasCancelled {
                self.pagedImageView.completeTransition()
            }
            transitionImageView.removeFromSuperview()
            bgView.removeFromSuperview()

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
