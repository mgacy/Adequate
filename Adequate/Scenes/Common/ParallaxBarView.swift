//
//  ParallaxBarView.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/5/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class ParallaxBarView: UIView {

    var progressHandler: ((CGFloat) -> Void)?

    /// Difference between the vertical component of the scroll view's coordinate system
    /// and that of the navigation bar. It is expected that this view and the scroll view
    /// will have the same coordinate system (at least with respect to the vertical dimension).
    var coordinateOffset: CGFloat = 0.0

    /// Additional offset to apply.
    var additionalOffset: CGFloat = 0.0

    private(set) var progress: CGFloat = 0.0 {
        didSet {
            guard progress != oldValue else {
                return
            }
            updateAlpha(for: progress)
            progressHandler?(progress)
        }
    }

    private var coveringHeightConstraint: NSLayoutConstraint!

    // MARK: - Subviews

    private let coveringView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    private func configure() {
        clipsToBounds = true
        addSubview(coveringView)
        isUserInteractionEnabled = false
        configureConstraints()
    }

    private func configureConstraints() {
        coveringHeightConstraint = coveringView.heightAnchor.constraint(equalToConstant: 0.0)
        NSLayoutConstraint.activate([
            coveringHeightConstraint,
            coveringView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coveringView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coveringView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - A

    /// Update appearance based on y value of scroll view's contentOffset
    ///
    /// - Parameter yOffset: y value of scrollview `contentOffset`
    func updateProgress(yOffset: CGFloat) {
        let relativeHeight = -yOffset + additionalOffset
        if relativeHeight >= bounds.height {
            coveringHeightConstraint.constant = 0
            progress = 0.0
        } else if relativeHeight <= coordinateOffset {
            coveringHeightConstraint.constant = frame.height
            progress = 1.0
        } else {
            // calculate progress
            guard bounds.height > 0 else {
                coveringHeightConstraint.constant = 0
                progress = 0.0
                return
            }
            // Calculate distance from top of scroll view's content to bottom of navigation bar
            let distance = bounds.height - relativeHeight
            coveringHeightConstraint.constant = distance
            progress = distance / (bounds.height - coordinateOffset)
        }
    }

    // MARK: - Helper Methods

    private func updateAlpha(for progress: CGFloat) {
        let bgColor = (backgroundColor ?? .red).withAlphaComponent(progress)
        backgroundColor = bgColor
    }
}

// MARK: - Themeable
extension ParallaxBarView: Themeable {
    func apply(theme: ColorTheme) {
        backgroundColor = theme.systemBackground.withAlphaComponent(progress)
        coveringView.backgroundColor = theme.systemBackground
    }
}
