//
//  DimmingPresentationController.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/2/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class DimmingPresentationController: UIPresentationController {

    private let dimmmingColor: UIColor = .black
    private let dimmingAlpha: CGFloat = 0.5
    private var dimmingView: UIView!

    override func presentationTransitionWillBegin() {
        guard
            let transitionCoordinator = presentingViewController.transitionCoordinator,
            let `containerView` = containerView else {
                return
        }

        dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = dimmmingColor.withAlphaComponent(dimmingAlpha)
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView)
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
            dimmingView = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            dimmingView = nil
        }
    }

}
