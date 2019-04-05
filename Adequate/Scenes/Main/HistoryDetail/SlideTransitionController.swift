//
//  SlideTransitionController.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/8/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol SwipeDismissable: class {
    var shouldDismiss: Bool { get }
    var transitionController: UIViewControllerTransitioningDelegate? { get set }
    func attachTransitionController(onFinishDismissal: (() -> Void)?)
}

extension SwipeDismissable where Self: UIViewController {

    /// NOTE: when used with a view controller in a navigation controller, this must be called
    /// after the view controller is embedded in the navigation controller
    func attachTransitionController(onFinishDismissal: (() -> Void)?) {
        let transitionController = SlideTransitionController(viewController: self)
        transitionController.onFinishDismissal = onFinishDismissal

        self.transitionController = transitionController
        if let navigationController = self.navigationController {
            navigationController.transitioningDelegate = transitionController
            navigationController.modalPresentationStyle = .custom
        } else {
            transitioningDelegate = transitionController
            modalPresentationStyle = .custom
        }
    }
}

// MARK: - Transition Controller

class SlideTransitionController: NSObject {
    typealias ViewControllerType = UIViewController & SwipeDismissable

    // TODO: replace with delegate protocol?
    var onFinishDismissal: (() -> Void)? = nil

    weak var viewController: ViewControllerType!
    //var isInteracting: Bool = false

    // Pan down transitions back to the presenting view controller
    var interactionController: UIPercentDrivenInteractiveTransition?

    lazy private var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        recognizer.delegate = self

        // Avoid unexpected behavior when touch event occurs near edge of screen
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()

    // MARK: - Lifecycle

    init(viewController: ViewControllerType) {
        self.viewController = viewController
        super.init()
        viewController.view.addGestureRecognizer(panGestureRecognizer)
        // TODO: go ahead and set .transitionController here?
        // TODO: go ahead and set .transitioningDelegate (on .navigationController / .viewController) here?
    }

    deinit { print("\(#function) - \(self.description)") }

    // MARK: - Gestures

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let percent = translation.y / gesture.view!.bounds.size.height

        switch gesture.state {
        case .began:
            //isInteracting = true
            interactionController = UIPercentDrivenInteractiveTransition()
            // TODO: use completion handler on .dismiss(animated:, completion:) to call didDismiss delegate method
            viewController.dismiss(animated: true)

            /// https://stackoverflow.com/a/50238562/4472195
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.interactionController?.update(percent)
            }
        case .changed:
            interactionController?.update(percent)
        case .cancelled:
            //isInteracting = false
            interactionController = nil
        case .ended:
            //isInteracting = false
            let velocity = gesture.velocity(in: gesture.view)
            /// https://stackoverflow.com/a/42972283/1271826
            interactionController?.completionSpeed = 0.999
            if (percent > 0.5 && velocity.y >= 0) || velocity.y > 0 {
                interactionController?.finish()
                onFinishDismissal?()
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

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIPanGestureRecognizer else {
            return false
        }
        // Dismiss only if the scroll view is at the top
        return viewController.shouldDismiss ? true : false
    }

}

// MARK: - UIViewControllerTransitioningDelegate
extension SlideTransitionController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(transitionType: .presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(transitionType: .dismissing)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        //return isInteracting ? interactionController : nil
        return interactionController
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }

}
