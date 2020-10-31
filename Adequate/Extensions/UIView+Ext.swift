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
