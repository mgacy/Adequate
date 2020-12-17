//
//  Insets+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/10/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

extension NSDirectionalEdgeInsets {

    /// Initializes the edge inset struct.
    /// - Parameters:
    ///   - horizontal: The inset on the leading and trailing edges.
    ///   - vertical: The inset on the top and bottom edges.
    public init(horizontal: CGFloat = 0.0, vertical: CGFloat = 0.0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}

extension UIEdgeInsets {

    /// Initializes the edge inset struct.
    /// - Parameters:
    ///   - horizontal: The inset on the leading and trailing edges.
    ///   - vertical: The inset on the top and bottom edges.
    public init(horizontal: CGFloat = 0.0, vertical: CGFloat = 0.0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
