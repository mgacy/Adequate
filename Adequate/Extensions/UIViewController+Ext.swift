//
//  UIViewController+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/6/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Child View Controllers
// https://www.swiftbysundell.com/basics/child-view-controllers?rq=child
extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK: - Properties
extension UIViewController {

    /// Best guess at a correct frame to use when using a custom view in `loadView()`.
    var defaultFrame: CGRect {
        return parent?.view.frame ?? UIScreen.main.bounds
    }
}
