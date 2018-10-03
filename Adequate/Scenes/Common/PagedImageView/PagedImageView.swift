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
            //collectionView.backgroundColor = backgroundColor
            pageControl.backgroundColor = backgroundColor
        }
    }
    private var pageControlHeight: CGFloat = 30.0

    // MARK: - Views

    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

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
        self.backgroundColor = .cyan
        // ...
        addSubview(pageControl)
        setupConstraints()
        updatePageControl()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // pageController
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }

    // MARK: - Images

    public func updateImages(with urls: [URL]) {
        //dataSource.urls = urls
        //collectionView.reloadData()
        //updatePageControl()
    }

    // MARK: - Pages

    // ...

    // MARK: - Appearance / Sizing

    private func updatePageControl() {
        pageControl.numberOfPages = 5
        pageControl.currentPage = currentPage
    }

}

// MARK: - Themeable
extension PagedImageView: Themeable {
    func apply(theme: Theme) {
        // ...
    }
}
