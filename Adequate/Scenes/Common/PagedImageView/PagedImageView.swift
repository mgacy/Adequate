//
//  PagedImageView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class PagedImageView: UIView {

    var currentPage: Int = 0
    var isPaging: Bool = false

    var originFrame: CGRect {
        return convert(collectionView.frame, to: nil)
    }

    var visibleImage: Promise<UIImage> {
        return dataSource.imageSource(for: IndexPath(item: primaryVisiblePage, section: 0))
    }

    var primaryVisiblePage: Int {
        return collectionView.frame.size.width > 0 ? Int(collectionView.contentOffset.x + collectionView.frame.size.width / 2) / Int(collectionView.frame.size.width) : 0
    }

    private let dataSource = PagedImageViewDataSource()
    weak var delegate: PagedImageViewDelegate?

    // MARK: - Appearance

    override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
            pageControl.backgroundColor = backgroundColor
        }
    }
    //private var pageControlHeight: CGFloat = 30.0

    // MARK: - Subviews

    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        view.isPagingEnabled = true
        view.isPrefetchingEnabled = true
        view.showsHorizontalScrollIndicator = false
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

    // MARK: - Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    // MARK: - Configuration

    private func configure() {
        // collectionView
        collectionView.register(cellType: ImageCell.self)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        addSubview(collectionView)

        // pageControl
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        addSubview(pageControl)

        setupConstraints()
        updatePageControl()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // collectionView
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -8.0),
            // pageController
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }

    // MARK: - Images

    public func updateImages(with urls: [URL]) {
        dataSource.updateImages(with: urls)
        collectionView.reloadData()
        updatePageControl()
    }

    // MARK: Selection

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.displayFullscreenImage(animatingFrom: self)
    }

    // MARK: - Pages

    @objc private func pageControlValueChanged() {
        isPaging = true
        let newPage = pageControl.currentPage
        currentPage = newPage
        collectionView.scrollRectToVisible(makeRect(forPage: newPage), animated: true)
    }

    // MARK: - Appearance / Sizing

    public func beginRotation() {
        collectionView.isHidden = true
        flowLayout.invalidateLayout()
    }

    public func completeRotation(page currentPage: Int) {
        collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally,
                                    animated: false)
        collectionView.isHidden = false
    }

    private func updatePageControl() {
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: 0)
        pageControl.currentPage = currentPage
    }

    private func makeRect(forPage page: Int) -> CGRect {
        return CGRect(x: collectionView.frame.size.width * CGFloat(page), y: 0.0,
                      width: collectionView.frame.size.width,
                      height: collectionView.frame.size.height)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension PagedImageView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isPaging {
            pageControl.currentPage = primaryVisiblePage
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isPaging = false
    }

}

// MARK: - Themeable
extension PagedImageView: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        pageControl.currentPageIndicatorTintColor = theme.accentColor
        pageControl.pageIndicatorTintColor = theme.accentColor.withAlphaComponent(0.3)
        // backgroundColor
        self.backgroundColor = theme.backgroundColor
        // foreground

        // Subviews
        dataSource.apply(theme: theme)
    }
}
