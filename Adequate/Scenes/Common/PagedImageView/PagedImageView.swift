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
final class PagedImageView: UIView {

    private(set) var currentPage: Int = 0

    private let dataSource: PagedImageViewDataSourceType
    weak var delegate: PagedImageViewDelegate?

    /// Flag indicating that `pageControl` has initiated collection view scrolling and should not be updated via `scrollViewDidScroll(_:)`.
    private var isPaging: Bool = false

    /// View state of the currently visible cell.
    var visibleImageState: ViewState<UIImage>? {
        guard let firstImageCell = collectionView.visibleCells.first as? ImageCell else {
            return nil
        }
        return firstImageCell.viewState
    }

    // FIXME: consolidate `currentPage`, `primaryVisiblePage`, `visibleImageState`, and `visibleImage` (and `focusedIndexPath`?) and the methods they use to determine the current page
    /// Predominantly visible page; used to update `currentPage` and `pageControl.currentPage` when user is scrolling `collectionView`.
    private var primaryVisiblePage: Int {
        return collectionView.frame.size.width > 0 ? Int(collectionView.contentOffset.x + collectionView.frame.size.width / 2) / Int(collectionView.frame.size.width) : 0
    }

    /// Currently visible page at the beginning of rotation; used to restore state following rotation and layout invalidation.
    private var focusedIndexPath: IndexPath?

    /// Temporary view used to cover `collectionView` and hide layout invalidation during rotation.
    private var coveringImageView: UIView?

    // MARK: - Appearance

    override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
            pageControl.backgroundColor = backgroundColor
        }
    }

    /// Height of `pageControl` subview.
    let pageControlHeight: CGFloat = 24.0

    // MARK: - Subviews

    // TODO: add `resetLayout()` method rather than make this accessible?
    lazy var flowLayout: UICollectionViewFlowLayout = {
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
        clipsToBounds = true
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
        currentPage = 0
        updatePageControl()
    }

    public func reloadVisibleImage() {
        // TODO: replace with:
        //collectionView.reloadItems(at: [IndexPath(item: currentPage, section: 0)])
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
        // TODO: replace with:
        //collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0),
        //                            at: .centeredHorizontally, animated: true)
        collectionView.scrollRectToVisible(makeRect(forPage: newPage), animated: true)
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

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isPaging {
            currentPage = primaryVisiblePage
            pageControl.currentPage = primaryVisiblePage
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isPaging = false
    }
}

// MARK: - Rotation Helpers
extension PagedImageView {

    public func beginRotation() {
        //focusedIndexPath = IndexPath(item: currentPage, section: 0)
        focusedIndexPath = collectionView.indexPathsForVisibleItems.first

        coveringImageView?.removeFromSuperview()
        guard !collectionView.isHidden, let view = makeTransitioningView() else {
            return
        }
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -pageControlHeight),
        ])

        layoutIfNeeded()
        coveringImageView = view
    }

    public func completeRotation() {
        layoutIfNeeded()
        flowLayout.invalidateLayout()
        // TODO: set flowLayout.estimatedItemSize using value from VC.viewWillTransition(to:, with:)?
        // https://stackoverflow.com/a/52281704/4472195
        if let idx = focusedIndexPath {
            isPaging = true
            collectionView.scrollToItem(at: idx, at: .centeredHorizontally, animated: false)
            focusedIndexPath = nil
        }
        coveringImageView?.removeFromSuperview()
        coveringImageView = nil
    }
}

// MARK: - View Controller Presentation Animation Helpers
extension PagedImageView {

    var visibleImage: Promise<UIImage> {
        // FIXME: this can cause a crash when dataSource.urls == []
        //guard dataSource.collectionView(collectionView, numberOfItemsInSection: 0) >= primaryVisiblePage else {}
        return dataSource.imageSource(for: IndexPath(item: primaryVisiblePage, section: 0))
    }

    /// Hide views that will be animated during presentation and dismissal of `FullScreenImageViewController`.
    // TODO: rename `transitionAnimationWillStart()`
    public func beginTransition() {
        collectionView.isHidden = true
    }

    /// Show views that were animated during presentation and dismissal of `FullScreenImageViewController`.
    // TODO: rename `transitionAnimationDidEnd()`
    public func completeTransition() {
        collectionView.isHidden = false
    }
}

// MARK: - ViewAnimatedTransitioning
extension PagedImageView: ViewAnimatedTransitioning {

    var originFrame: CGRect {
        return convert(collectionView.frame, to: nil)
    }

    var originView: UIView {
        return collectionView
    }

    func makeTransitioningView() -> UIView? {
        let v: UIView
        // TODO: use `currentPage` rather than `primaryVisiblePage`?
        if let visibleImageView = dataSource.imageSource(for: IndexPath(item: primaryVisiblePage, section: 0)).value {
            v = UIImageView(image: visibleImageView)
            v.contentMode = .scaleAspectFit
            //v.frame = originFrame
        } else {
            v = UIView(frame: originFrame)
            v.backgroundColor = .red
        }
        return v
    }
}

// MARK: - UICollectionViewDelegate
// TODO: move to PagedImageViewDataSource?
extension PagedImageView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !dataSource.imageSource(for: indexPath).isRejected ? true : false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.displayFullScreenImage(dataSource: dataSource, indexPath: IndexPath(item: primaryVisiblePage, section: 0))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PagedImageView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - Themeable
extension PagedImageView: Themeable {
    func apply(theme: ColorTheme) {
        // accentColor
        pageControl.currentPageIndicatorTintColor = theme.tint
        pageControl.pageIndicatorTintColor = theme.tertiaryTint

        // backgroundColor
        backgroundColor = theme.systemBackground

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
}
