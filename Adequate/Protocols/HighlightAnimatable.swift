//
//  HighlightAnimatable.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/24/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

protocol HighlightAnimatable where Self: UIView {

    /// Color for normal state.
    var normalColor: UIColor? { get }

    /// Color for highlighted state.
    var highlightedColor: UIColor? { get }
}

protocol HighlightAnimating {
    associatedtype ViewType

    /// Animate change in view's state.
    /// - Parameters:
    ///   - : The view to animate.
    ///   - isHighlighted: Pass `true` to animate change to `highlightColor`; pass `false` to animate change to
    ///   `normalColor`.
    static func animateStateChange(_: ViewType, isHighlighted: Bool)
}

// Protocol allows use of StyleBook.Book styles with `MGButton`.
protocol AnimatableButton: HighlightAnimatable, Themeable where Self: UIButton {}
