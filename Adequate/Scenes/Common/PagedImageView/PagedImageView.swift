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

    private(set) var currentPage: Int = 0 {
        didSet {
            if oldValue != currentPage {
                pageControl.currentPage = currentPage
            }
        }
    }

    private let dataSource: PagedImageViewDataSourceType
    weak var delegate: PagedImageViewDelegate?

    /// View state of the currently visible cell.
    var visibleImageState: ViewState<UIImage>? {
        guard let firstImageCell = collectionView.visibleCells.first as? ImageCell else {
            return nil
        }
        return firstImageCell.viewState
    }

    /// Flag indicating that `pageControl` should be updated  via `scrollViewDidScroll(_:)`.
    private var updatePageControlDuringScroll: Bool = true

    /// Predominantly visible page; used to update `currentPage` and `pageControl.currentPage` when user is scrolling `collectionView`.
    private var primaryVisiblePage: Int {
        // swiftlint:disable:next line_length
        return collectionView.frame.size.width > 0 ? Int(collectionView.contentOffset.x + collectionView.frame.size.width / 2) / Int(collectionView.frame.size.width) : 0
    }

    /// Temporary view used to cover `collectionView` and hide layout invalidation during rotation.
    private var coveringImageView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
        }
    }

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

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: frame, collectionViewLayout: makeAdaptiveLayout())
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
        dataSource.addDataSource(toCollectionView: collectionView)
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
        dataSource.update(with: urls, animatingDifferences: true) { [weak self] in
            if let currentPage = self?.currentPage, currentPage > 0 {
                // FIXME: it looks on iOS 13, UICollectionView.scrollToItem(at:animated:) does not respect NSCollectionItem.contentInsets when using UICollectionViewCompositionalLayout
                self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
                self?.currentPage = 0
            }
            self?.updatePageControl()
        }
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
        let promise = dataSource.imageSource(for: IndexPath(row: currentPage, section: 0))
        firstImageCell.configure(with: promise)
    }

    // MARK: - Pages

    @objc private func pageControlValueChanged() {
        currentPage = pageControl.currentPage
        updatePageControlDuringScroll = false
        collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0),
                                    at: .centeredHorizontally, animated: true)
    }

    private func updatePageControl() {
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: 0)
        pageControl.currentPage = currentPage
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if updatePageControlDuringScroll {
            currentPage = primaryVisiblePage
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updatePageControlDuringScroll = true
    }
}

// MARK: - Configuration
extension PagedImageView {

    private func makeAdaptiveLayout() -> UICollectionViewLayout {
        // (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
        let provider: UICollectionViewCompositionalLayoutSectionProvider = { _, layoutEnvironment in
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = layoutEnvironment.traitCollection.horizontalSizeClass.directionalEdgeInsets

            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        return UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: config)
    }
}

// MARK: - Rotation Helpers
extension PagedImageView {

    public func beginRotation() {
        updatePageControlDuringScroll = false
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
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -pageControlHeight)
        ])

        layoutIfNeeded()
        coveringImageView = view
    }

    public func completeRotation() {
        layoutIfNeeded()
        if collectionView.numberOfItems(inSection: 0) > 0 {
            updatePageControlDuringScroll = false
            collectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0),
                                        at: .centeredHorizontally, animated: false)
        }
        coveringImageView = nil
        updatePageControlDuringScroll = true
    }
}
/*
// MARK: - View Controller Presentation Animation Helpers
extension PagedImageView {

    var visibleImage: Promise<UIImage> {
        // FIXME: this can cause a crash when dataSource.urls == []
        //guard dataSource.collectionView(collectionView, numberOfItemsInSection: 0) >= primaryVisiblePage else {}
        return dataSource.imageSource(for: IndexPath(item: primaryVisiblePage, section: 0))
    }

    /// Hide views that will be animated during presentation and dismissal of `FullScreenImageViewController`.
    public func transitionAnimationWillStart() {
        collectionView.isHidden = true
    }

    /// Show views that were animated during presentation and dismissal of `FullScreenImageViewController`.
    public func transitionAnimationDidEnd() {
        collectionView.isHidden = false
    }
}
*/
// MARK: - ViewAnimatedTransitioning
extension PagedImageView: ViewAnimatedTransitioning {

    var originFrame: CGRect {
        return convert(collectionView.frame.inset(by: traitCollection.horizontalSizeClass.edgeInsets), to: nil)
    }

    var originView: UIView {
        return collectionView
    }

    func makeTransitioningView() -> UIView? {
        // FIXME: whenever app enters background, the memory cache evicts all objects. This causes problems if user
        // returns and then tries to display a fullscreen image since dataSource.imageSource(for:) will refetch image
        // and this method will return the fake image view

        // TODO: should we just make the datasource responsible for this? It's not much different from providing a
        // UICollectionViewCell. We could pass the collectionView so that PagedImageViewDataSource can use the actual
        // dataSource's methods to get the cell (allowing us to get the image that way, in case the cache has been
        // cleared.
        // swiftlint:disable:next identifier_name
        let v: UIView
        if let visibleImageView = dataSource.imageSource(for: IndexPath(item: currentPage, section: 0)).value {
            v = UIImageView(image: visibleImageView)
            v.contentMode = .scaleAspectFit
            //v.frame = originFrame
        } else {
            // Alternatively, we could just add an loading image resource
            v = LoadingView(frame: originFrame)
        }
        return v
    }
}

// MARK: - UICollectionViewDelegate
extension PagedImageView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !dataSource.imageSource(for: indexPath).isRejected ? true : false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: try to get image directly from cell to avoid problem with emptied cache
        delegate?.displayFullScreenImage(dataSource: dataSource,
                                         indexPath: IndexPath(item: primaryVisiblePage, section: 0))
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

// MARK: - Helper
fileprivate extension UIUserInterfaceSizeClass {

    /// Insets for `PagedImageView.collectionView`.
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .compact: return .init(horizontal: 16.0)
        default: return .init(horizontal: 20.0)
        }
    }

    /// Insets used for `NSCollectionLayoutItem.contentInset` in `PagedImageView.collectionView`.
    var directionalEdgeInsets: NSDirectionalEdgeInsets {
        switch self {
        case .compact: return .init(horizontal: 16.0)
        default: return .init(horizontal: 20.0)
        }
    }
}
