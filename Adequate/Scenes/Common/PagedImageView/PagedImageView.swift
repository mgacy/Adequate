//
//  PagedImageView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

// TODO: subclass UIViewController
class PagedImageView: UIView {

    var currentPage: Int = 0
    private var isPaging: Bool = false

    var originFrame: CGRect {
        return convert(collectionView.frame, to: nil)
    }

    var visibleImage: Promise<UIImage> {
        // FIXME: this can cause a crash when dataSource.urls == []
        //guard dataSource.collectionView(collectionView, numberOfItemsInSection: 0) >= primaryVisiblePage else {}
        return dataSource.imageSource(for: IndexPath(item: primaryVisiblePage, section: 0))
    }

    var visibleImageState: ViewState<UIImage>? {
        guard let firstImageCell = collectionView.visibleCells.first as? ImageCell else {
            return nil
        }
        return firstImageCell.viewState
    }

    var primaryVisiblePage: Int {
        return collectionView.frame.size.width > 0 ? Int(collectionView.contentOffset.x + collectionView.frame.size.width / 2) / Int(collectionView.frame.size.width) : 0
    }

    private let dataSource: PagedImageViewDataSourceType
    weak var delegate: PagedImageViewDelegate?

    // MARK: - Appearance

    override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
            pageControl.backgroundColor = backgroundColor
        }
    }

    let pageControlHeight: CGFloat = 24.0

    // MARK: - Subviews

    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        view.isPagingEnabled = true
        view.isPrefetchingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = control.tintColor.withAlphaComponent(0.3)
        control.currentPageIndicatorTintColor = control.tintColor
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    // MARK: - Lifecycle

    init(imageService: ImageServiceType) {
        self.dataSource = PagedImageViewDataSource(imageService: imageService)
        super.init(frame: CGRect.zero)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -0.0),
            // pageController
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: pageControlHeight)
        ])
    }

    // MARK: - Images

    public func updateImages(with urls: [URL]) {
        // TODO: dataSource should verify that new URLs differ from old; use difference(from:) and .performBatchUpdates() instead of .reloadData()?
        dataSource.updateImages(with: urls)
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        updatePageControl()
    }

    public func reloadVisibleImage() {
        guard
            let firstImageCell = collectionView.visibleCells.first as? ImageCell,
            firstImageCell.viewState != .loading else {
                log.warning("Visible image is already loading")
                return
        }
        let promise = dataSource.imageSource(for: IndexPath(row: primaryVisiblePage, section: 0))
        firstImageCell.configure(with: promise)
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
    }

    public func completeRotation(page currentPage: Int) {
        layoutIfNeeded()
        flowLayout.invalidateLayout()
        // TODO: set flowLayout.estimatedItemSize using value from VC.viewWillTransition(to:, with:)?
        // https://stackoverflow.com/a/52281704/4472195
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

// MARK: - UICollectionViewDelegate
// TODO: move to PagedImageViewDataSource?
extension PagedImageView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !dataSource.imageSource(for: indexPath).isRejected ? true : false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.displayFullscreenImage(animatingFrom: self)
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
        /*
        // TODO: apply theme to all visible cells as well; use self.visibleCells?
        collectionView.visibleCells.forEach { cell in
            if let imageCell = cell as? ImageCell {
                imageCell.apply(theme: theme)
            }
        }
        */
    }

    func apply(theme: ColorTheme) {
        // accentColor
        pageControl.currentPageIndicatorTintColor = theme.label
        pageControl.pageIndicatorTintColor = theme.label.withAlphaComponent(0.3)
        //pageControl.pageIndicatorTintColor = theme.tertiaryLabel

        // backgroundColor
        backgroundColor = theme.systemBackground

        // Subviews
        // TODO: we should set `dataSource.theme` to `nil` so that it doesn't apply theme to `ImageCell.stateView`
        dataSource.apply(theme: theme)
    }
}
