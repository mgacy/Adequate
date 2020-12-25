//
//  HighlightAnimators.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/24/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

enum ButtonAnimator: HighlightAnimating {
    private static let depressAnimationDuration: TimeInterval = 0.1
    private static let releaseAnimationDuration: TimeInterval = 0.2

    static func animateStateChange(_ button: HighlightAnimatable, isHighlighted: Bool) {
        let duration: TimeInterval = isHighlighted ? Self.depressAnimationDuration : Self.releaseAnimationDuration
        let color: UIColor? = isHighlighted ? button.highlightedColor : button.normalColor

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                button.backgroundColor = color
            }
        )
    }
}

enum OutlineButtonAnimator: HighlightAnimating {
    private static let depressAnimationDuration: TimeInterval = 0.1
    private static let releaseAnimationDuration: TimeInterval = 0.2

    static func animateStateChange(_ button: HighlightAnimatable, isHighlighted: Bool) {
        let duration: TimeInterval = isHighlighted ? Self.depressAnimationDuration : Self.releaseAnimationDuration
        let borderColor: UIColor? = isHighlighted ? button.highlightedColor : button.normalColor
        let backgroundColor: UIColor? = isHighlighted ? button.highlightedColor?.withAlphaComponent(0.3) : .clear

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                if let color = borderColor {
                    button.layer.borderColor = color.cgColor
                }
                button.backgroundColor = backgroundColor
            }
        )
    }
}
