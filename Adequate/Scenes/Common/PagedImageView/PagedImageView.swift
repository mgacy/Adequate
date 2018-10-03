//
//  PagedImageView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class PagedImageView: UIView {

    var currentPage: Int = 0

    // MARK: - Appearance

    override var backgroundColor: UIColor? {
        didSet {
            imageView.backgroundColor = backgroundColor
            pageControl.backgroundColor = backgroundColor
        }
    }
    private var pageControlHeight: CGFloat = 30.0

    // MARK: - Subviews

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = control.tintColor.withAlphaComponent(0.3)
        control.currentPageIndicatorTintColor = control.tintColor
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let dataSource = PagedImageViewDataSource()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(imageView)
        addSubview(pageControl)
        setupConstraints()
        updatePageControl()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            // pageController
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }

    // MARK: - Images

    public func updateImages(with urls: [URL]) {
        dataSource.updateImages(with: urls)
        dataSource.imageSource(for: 1).then({ image in
            self.imageView.image = image
        })
        updatePageControl()
    }

    // MARK: - Pages

    // ...

    // MARK: - Appearance / Sizing

    private func updatePageControl() {
        pageControl.numberOfPages = dataSource.numberOfItems()
        pageControl.currentPage = currentPage
    }

}

// MARK: - Themeable
extension PagedImageView: Themeable {
    func apply(theme: Theme) {
        // accentColor
        let accentColor = UIColor(hexString: theme.accentColor)
        pageControl.currentPageIndicatorTintColor = accentColor
        pageControl.pageIndicatorTintColor = accentColor.withAlphaComponent(0.3)
        // backgroundColor
        pageControl.pageIndicatorTintColor = UIColor(hexString: theme.backgroundColor)
    }
}
