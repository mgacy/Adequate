//
//  NSLayoutConstraint+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {

    /// Return activated copy of constraint with new multiplier.
    ///
    /// **NOTE**: This method deactivtates the constraint to which it is applied and activates the copy.
    ///
    /// - Parameter multiplier: The new multiplier to be applied to the second attribute participating in the
    ///                         constraint.
    /// - Returns: Activated copy of the constraint.
    func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority

        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])

        return newConstraint
    }

    /// Return constraint with mutated priority.
    /// - Parameter rawValue: Raw value of `UILayoutPriority`.
    /// - Returns: Constraint.
    func withPriority(_ rawValue: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue)
        return self
    }
}
