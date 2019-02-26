//
//  ZoomInAnimationController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class ZoomInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let sourceFrame: CGRect

    init(sourceFrame: CGRect) {
        self.sourceFrame = sourceFrame
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /// TODO: cast fromVC and toVC as protocol to get access to properties
        guard
            let fromNavController = transitionContext.viewController(forKey: .from) as? UINavigationController,
            let fromVC = fromNavController.topViewController as? DealViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? FullScreenImageViewController else {
                fatalError("ERROR: failed to cast as correct view controllers for transition")
        }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        /// TODO: is fromVC displaying image / activityIndicator (/ error?)

        toVC.view.isHidden = true
        toVC.view.frame = finalFrame
        containerView.addSubview(toVC.view)

        // snapshot
        let snapshot = fromNavController.view.snapshotView(afterScreenUpdates: true)
        containerView.addSubview(snapshot!)

        // sourceImageCoveringView
        let sourceImageCoveringView = UIView(frame: sourceFrame)
        sourceImageCoveringView.backgroundColor = fromVC.view.backgroundColor
        containerView.addSubview(sourceImageCoveringView)

        // background
        let bgView = UIView(frame: finalFrame)
        bgView.backgroundColor = .black
        bgView.alpha = 0.0
        containerView.addSubview(bgView)

        // image
        let transitionImageView: UIView
        let scaledSize: CGSize
        // We need to cast fromVC as DealViewController to get .visibleImage
        if let transitionImage = fromVC.visibleImage.value {
            transitionImageView = UIImageView(image: transitionImage)
            transitionImageView.frame = sourceFrame
            transitionImageView.contentMode = .scaleAspectFit
            scaledSize = finalFrame.size
        } else {
            transitionImageView = UIView(frame: sourceFrame)
            //transitionImageView.backgroundColor = .red
            let scaleFactor = min(finalFrame.width / sourceFrame.width, finalFrame.height / sourceFrame.height)
            scaledSize = CGSize(width: sourceFrame.width * scaleFactor, height: sourceFrame.height * scaleFactor)
        }
        containerView.addSubview(transitionImageView)

        // Animation
        let animation: () -> Void = { () in
            //transitionImageView.frame = finalFrame
            transitionImageView.frame.size = scaledSize
            transitionImageView.center = toVC.view.center
            bgView.alpha = 1.0
            toVC.view.isHidden = false
        }

        // Completion
        let completion  = { (_ finished: Bool) -> Void in
            transitionImageView.removeFromSuperview()
            bgView.removeFromSuperview()
            sourceImageCoveringView.removeFromSuperview()
            snapshot?.removeFromSuperview()

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
                       options: [UIView.AnimationOptions.curveEaseOut],
                       animations: animation,
                       completion: completion)
    }

}
