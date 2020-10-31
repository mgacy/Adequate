//
//  UIView+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 1/1/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Properties
extension UIView {

    /// The height of the frame minus the top and bottom directional layout margins.
    public var contentHeight: CGFloat {
        guard frame.height > 0.0 else {
            return 0.0
        }
        return frame.height - directionalLayoutMargins.top - directionalLayoutMargins.bottom
    }

    /// The width of the frame minus the leading and trailing directional layout margins.
    public var contentWidth: CGFloat {
        guard frame.width > 0.0 else {
            return 0.0
        }
        return frame.width - directionalLayoutMargins.leading - directionalLayoutMargins.trailing
    }
}

// MARK: - Helpers
extension UIView {

    /// Returns superview with class name `className` if one exists.
    /// - Parameter className: Class name of superview.
    /// - Returns: Superview with class name `className`. Returns `nil` if view does not have matching superview.
    public func superview(withName className: String) -> UIView? {
        guard let superview = superview else {
            return nil
        }
        let stringFromClass = NSStringFromClass(superview.classForCoder)
        if stringFromClass == className {
            return superview
        } else {
            return superview.superview(withName: className)
        }
    }

    /// Returns first subview with class name `className` if one exists.
    /// - Parameter className: Class name of subview.
    /// - Returns: Subview with class name `className`. Returns `nil` if view does not have matching subview.
    public func subview(withName className: String) -> UIView? {
        for subview in subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass == className {
                return subview
            }
        }
        return nil
    }

    /// Returns first layout guide with identifier containing `substring` if one exists.
    /// - Parameter substring: Identifier of layout guide.
    /// - Returns: Layout guide with identifier `substring`. Returns `nil` if view does not have matching layout guide.
    public func layoutGuideWithIdentifier(containing substring: String) -> UILayoutGuide? {
        for layoutGuide in layoutGuides {
            if layoutGuide.identifier.contains(substring) {
                return layoutGuide
            }
        }
        return nil
    }
}
