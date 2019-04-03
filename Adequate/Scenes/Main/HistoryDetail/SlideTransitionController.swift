//
//  SlideTransitionController.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/8/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class SlideTransitionController: NSObject {

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

    // MARK: - Gestures

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
        return SlideAnimationController(transitionType: .presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(transitionType: .dismissing)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }

}
