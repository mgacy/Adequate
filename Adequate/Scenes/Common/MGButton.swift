//
//  MGButton.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/24/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

class MGButton<T: HighlightAnimating>: UIButton, AnimatableButton where T.ViewType == HighlightAnimatable {

    // swiftlint:disable:next weak_delegate
    let animationDelegate: T.Type

    public var touchClosure: ((MGButton) -> Void)?

    // MARK: - Appearance

    var normalColor: UIColor?
    var highlightedColor: UIColor?
    var disabledColor: UIColor?

    //override var isEnabled: Bool {
    //    didSet {
    //        changeEnabled(isEnabled)
    //    }
    //}

    // MARK: - Lifecycle

    public init(animationDelegate: T.Type, frame: CGRect = .zero) {
        self.animationDelegate = animationDelegate
        super.init(frame: frame)
        configureActions()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureActions() {
        // Handle action
        addTarget(self, action: #selector(onActionTriggered(_:)), for: .primaryActionTriggered)

        // Handle state animation
        addTarget(self, action: #selector(onTouchDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(onTouchDragEnter(_:)), for: .touchDragEnter)
        addTarget(self, action: #selector(onTouchDragExit(_:)), for: .touchDragExit)
        addTarget(self, action: #selector(onTouchUpInside(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(onTouchCancel(_:)), for: .touchCancel)
    }

    // MARK: - Actions

    @objc private func onActionTriggered(_ sender: UIButton) {
        touchClosure?(self)
    }

    // MARK: - State Change

    @objc private func onTouchDown(_ sender: UIButton) {
        changeState(isHighlighted: isHighlighted)
    }

    @objc private func onTouchDragEnter(_ sender: UIButton) {
        changeState(isHighlighted: isHighlighted)
    }

    @objc private func onTouchDragExit(_ sender: UIButton) {
        changeState(isHighlighted: isHighlighted)
    }

    @objc private func onTouchUpInside(_ sender: UIButton) {
        changeState(isHighlighted: false)
    }

    @objc private func onTouchUpCancel(_ sender: UIButton) {
        changeState(isHighlighted: isHighlighted)
    }

    @objc private func onTouchCancel(_ sender: UIButton) {
        changeState(isHighlighted: false)
    }

    // MARK: - State Change

    private func changeState(isHighlighted: Bool) {
        T.animateStateChange(self, isHighlighted: isHighlighted)
    }

    //private func changeEnabled(_ enabled: Bool) {}
}

// MARK: - Themeable
extension MGButton: Themeable {

    func apply(theme: ColorTheme) {
        normalColor = theme.tint
        highlightedColor = theme.secondaryTint
        disabledColor = theme.secondaryTint
    }
}
