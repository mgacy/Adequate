//
//  SlideTransitionController.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/8/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class SlideTransitionController: NSObject {

    //var originFrame: CGRect
    weak var viewController: UIViewController!
    var interacting: Bool = false

    // Pan down transitions back to the presenting view controller
    var interactionController: UIPercentDrivenInteractiveTransition?

    lazy private var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        recognizer.delegate = self

        // Avoid unexpected behavior when touch event occurs near edge of screen
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()

    // MARK: - Lifecycle

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
        viewController.view.addGestureRecognizer(panGestureRecognizer)
    }

    deinit { print("\(#function) - \(self.description)") }

    // MARK: - A

    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let percent = translation.y / gesture.view!.bounds.size.height

        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            viewController.dismiss(animated: true)

            /// https://stackoverflow.com/a/50238562/4472195
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.interactionController?.update(percent)
            }
        case .changed:
            interactionController?.update(percent)
        case .ended:
            let velocity = gesture.velocity(in: gesture.view)
            /// https://stackoverflow.com/a/42972283/1271826
            interactionController?.completionSpeed = 0.999
            if (percent > 0.5 && velocity.y >= 0) || velocity.y > 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            return
        }
    }

}

// MARK: - UIGestureRecognizerDelegate
extension SlideTransitionController: UIGestureRecognizerDelegate {

    // Recognize downward gestures only
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = pan.translation(in: pan.view)
            let angle = atan2(translation.y, translation.x)
            return abs(angle - .pi / 2.0) < (.pi / 8.0)
        }
        return false
    }

}

// MARK: - UIViewControllerTransitioningDelegate
extension SlideTransitionController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PanelAnimationController(transitionType: .presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PanelAnimationController(transitionType: .dismissing)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }

}

// MARK: - Z

protocol FooAnimating {
    var originFrame: CGRect { get }
}

protocol ImageSource {
    //var visibleImage:
}

// MARK: - A

// [robertmryan](https://github.com/robertmryan)
// [robertmryan/SwiftCustomTransitions](https://github.com/robertmryan/SwiftCustomTransitions/tree/rightside)
// FIXME: the above are under a Creative Commons License
// https://stackoverflow.com/a/42213998/4472195
class SheetPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return false }

    var dimmerView: UIView!
    //private var dimmerAlphaComponent: Float = 0.2
    //private var dimmerBackgroundColor: UIColor = black.withAlphaComponent(0.2)

    override func presentationTransitionWillBegin() {
        guard
            let transitionCoordinator = presentingViewController.transitionCoordinator,
            let `containerView` = containerView else {
                //log.error("\(#function) FAILED : unable get transitionCoordinator or containerView"); return
                print("\(#function) FAILED : unable get transitionCoordinator or containerView"); return

        }

        dimmerView = UIView(frame: containerView.bounds)
        dimmerView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmerView.alpha = 0
        containerView.addSubview(dimmerView)
        transitionCoordinator.animate(alongsideTransition: { _ in self.dimmerView.alpha = 1 }, completion: nil)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmerView.removeFromSuperview()
            dimmerView = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            //log.error("\(#function) FAILED : unable get transitionCoordinator"); return
            print("\(#function) FAILED : unable get transitionCoordinator"); return
        }
        transitionCoordinator.animate(alongsideTransition: { _ in self.dimmerView.alpha = 0 }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmerView.removeFromSuperview()
            dimmerView = nil
        }
    }

}

// MARK: - B

class PanelAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

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
        // TODO
        let dy = containerView.frame.size.height
        let finalFrame = transitionContext.finalFrame(for: toVC)

        //log.debug("\(#function): \(fromVC) -> \(toVC) in \(containerView)")

        toVC.view.frame = finalFrame.offsetBy(dx: 0.0, dy: dy)
        containerView.addSubview(toVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIView.AnimationOptions.curveEaseOut ],
            animations: {
                toVC.view.frame = finalFrame
        },
            completion: { _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled) }
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
        }, completion: { _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled) }
        )
    }

}
