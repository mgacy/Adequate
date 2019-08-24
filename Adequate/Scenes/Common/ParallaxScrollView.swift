//
//  ParallaxScrollView.swift
//  Adequate
//
//  Based on ParallaxHeader
//  Created by Roman Sorochak on 6/23/17.
//  Copyright © 2017 MagicLab. All rights reserved.
//

import UIKit

class ParallaxScrollView: UIScrollView {
    public typealias ParallaxHeaderHandlerBlock = (_ parallaxHeader: ParallaxScrollView) -> Void

    /// Block to handle parallax header scrolling.
    public var parallaxHeaderDidScrollHandler: ParallaxHeaderHandlerBlock?

    /// Rate at which headerView scrolls relative to scrollView content. 0.5 by default.
    var parallaxFactor: CGFloat = 0.5

    /// The header's view.
    private var _headerView: UIView?
    public var headerView: UIView? {
        get {
            return _headerView
        }
        set(view) {
            guard _headerView != view else {
                return
            }
            addSubview(contentView)
            //insertSubview(contentView, at: 0) // TODO: used this in `Adequate-iPad`
            _headerView = view
            updateHeaderConstraints()
        }
    }

    /// The header's default height. 0 by default.
    private var _headerHeight: CGFloat = 0
    public var headerHeight: CGFloat {
        get {
            return _headerHeight
        }
        set(height) {
            guard _headerHeight != height else {
                return
            }
            adjustScrollViewTopInset(
                top: contentInset.top - _headerHeight + height
            )

            _headerHeight = height

            updateHeaderConstraints()
            layoutContentView()
        }
    }

    /// The header's minimum height while scrolling up. 0 by default.
    public var minimumHeight: CGFloat = 0 {
        didSet {
            layoutContentView()
        }
    }

    /// The parallax header progress value.
    private var _progress: CGFloat = 0
    public var progress: CGFloat {
        get {
            return _progress
        }
        set(progress) {
            guard _progress != progress else {
                return
            }
            _progress = progress
            //print("Progress: \(progress)")
            parallaxHeaderDidScrollHandler?(self)
        }
    }

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.clipsToBounds = true
        return contentView
    }()

    // TESTING
    public var contentViewFrame: CGRect {
        return contentView.frame
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentView()
    }

    // MARK: Constraints

    func updateHeaderConstraints(update: Bool = false) {
        guard let headerView = headerView else {
            return
        }

        if !update {
            headerView.removeFromSuperview()
            contentView.addSubview(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }

    // MARK: Private

    private func setupConstraints() {
        guard let headerView = headerView else {
            return
        }

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //headerView.heightAnchor.constraint(equalTo: headerView.widthAnchor, constant: 0.0),
            headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: headerHeight),
            headerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            headerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        // Vertical
        let top = headerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        top.priority = UILayoutPriority(rawValue: 750) // TODO: increase priority?
        top.isActive = true

        let bottom = headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.priority = UILayoutPriority(rawValue: 750)
        bottom.isActive = true
    }

    private func layoutContentView() {
        let distance = contentOffset.y + adjustedContentInset.top
        var relativeYOffset = contentOffset.y + adjustedContentInset.top - headerHeight

        //print("distance: \(distance)")
        //print("offset: \(contentOffset.y) + inset: \(adjustedContentInset.top) - height: \(headerHeight) = \(relativeYOffset)")

        if distance > 0 {
            // TODO: handle if distance < minimumHeight?
            relativeYOffset -= (distance * parallaxFactor)
        }

        let frame = CGRect(x: 0, y: relativeYOffset, width: self.frame.size.width, height: headerHeight)
        contentView.frame = frame

        //let div = self.headerHeight - self.minimumHeight
        //progress = distance / div
        progress = distance / headerHeight
        //progress = contentOffset.y
    }

    private func adjustScrollViewTopInset(top: CGFloat) {
        var inset = contentInset

        // Adjust content offset
        var offset = contentOffset
        offset.y += inset.top - top
        contentOffset = offset

        // Adjust content inset
        inset.top = top
        contentInset = inset
    }
}

// MARK: - UIScrollViewDelegate
extension ParallaxScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutContentView()
        // TODO: just call `parallaxHeaderDidScrollHandler(self)` here?
    }
}
