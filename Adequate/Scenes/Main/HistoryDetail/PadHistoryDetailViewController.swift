//
//  PadHistoryDetailViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/18/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

final class PadHistoryDetailViewController: BaseViewController<ScrollablePadView<DealContentView>>, SwipeDismissable {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager
    typealias DealFragment = DealHistoryQuery.Data.DealHistory.Item
    typealias Deal = GetDealQuery.Data.GetDeal
    typealias Topic = GetDealQuery.Data.GetDeal.Topic
    typealias GraphQLID = String

    weak var delegate: HistoryDetailViewControllerDelegate?

    var shouldDismiss: Bool {
        return rootView.scrollView.contentOffset.y <= 0
    }

    // TODO: rename `interactionController?
    //var transitionController: SlideTransitionController?
    var transitionController: UIViewControllerTransitioningDelegate?

    private let dataProvider: DataProviderType
    private let imageService: ImageServiceType
    private let themeManager: ThemeManagerType
    private var dealFragment: DealFragment

    private var viewState: ViewState<Deal> = .empty {
        didSet {
            render(viewState)
        }
    }

    // MARK: Constraints

    private var sharedRegularConstraints: [NSLayoutConstraint] = []

    private var initialSetupDone = false

    // MARK: - Subviews

    private lazy var stateView: StateView = {
        let view = StateView(frame: UIScreen.main.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDeal(withID: strongSelf.dealFragment.id)
        }
        view.preservesSuperviewLayoutMargins = true
        return view
    }()

    // Navigation Bar

    private lazy var titleView: ParallaxTitleView = {
        let view = ParallaxTitleView(frame: CGRect(x: 0, y: 0, width: 800, height: 60))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    private lazy var dismissButton: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "CloseNavBar"), style: .plain, target: self, action: #selector(didPressDismiss(_:)))
    }()

    // Secondary Column

    private lazy var barBackingView: ParallaxBarView = {
        let view = ParallaxBarView()
        view.additionalOffset = 8.0 // DealContentView.layoutMargins.top
        view.progressHandler = { [weak self] progress in
            self?.titleView.progress = progress
            self?.rootView.contentView.titleLabel.alpha = 1 - progress
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // PagedImageView

    private lazy var pagedImageView: PagedImageView = {
        let view = PagedImageView(imageService: self.imageService)
        view.backgroundColor = ColorCompatibility.systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies, deal: DealFragment) {
        self.dataProvider = dependencies.dataProvider
        self.imageService = dependencies.imageService
        self.themeManager = dependencies.themeManager
        self.dealFragment = deal
        self.viewState = .empty
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure correct navigation bar style after aborted dismissal
        if themeManager.useDealTheme {
            navigationController?.navigationBar.barStyle = dealFragment.theme.foreground.navigationBarStyle
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - View Methods

    private func setupSubviews() {
        view.insertSubview(stateView, at: 0)
        view.addSubview(barBackingView)
        setupConstraints()
    }

    override func setupView() {
        setupSubviews()

        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = dismissButton
        StyleBook.NavigationItem.transparent.apply(to: navigationItem)
        pagedImageView.delegate = self

        rootView.contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)

        // barBackingView
        //if let navBar = navigationController?.navigationBar {
        //    barBackingView.coordinateOffset = navBar.convert(navBar.bounds, to: rootView.scrollView).minY
        //}

        // scrollView
        rootView.scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }

        getDeal(withID: dealFragment.id)
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        // Shared
        NSLayoutConstraint.activate([
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor),
            barBackingView.widthAnchor.constraint(equalTo: rootView.scrollView.widthAnchor),
        ])

        sharedRegularConstraints = [
            pagedImageView.centerYAnchor.constraint(equalTo: rootView.secondaryColumnGuide.centerYAnchor),
            pagedImageView.centerXAnchor.constraint(equalTo: rootView.secondaryColumnGuide.centerXAnchor),
            pagedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // Subtract 40 to compensate for margins on either side of PagedImageView.collectionView
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor,
                                                   constant: pagedImageView.pageControlHeight - 40)
        ]
    }

    override func setupObservations() -> [ObservationToken] {
        let themeToken = themeManager.addObserver(self)
        return [themeToken]
    }

    // MARK: - Navigation

    @objc private func didPressForum(_ sender: UIButton) {
        guard case .result(let deal) = viewState, let topic = deal.topic else {
            return
        }
        delegate?.showForum(with: topic)
    }

    @objc private func didPressDismiss(_ sender: UIBarButtonItem) {
        delegate?.dismiss()
    }

}

// MARK: - UIContentContainer
extension PadHistoryDetailViewController {

    // MARK: Trait Collection

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        let oldCollection = traitCollection
        coordinator.animate(
            alongsideTransition: { [unowned self] context in
                switch (oldCollection.horizontalSizeClass, newCollection.horizontalSizeClass) {
                case (.compact, .regular):
                    self.transitionToRegular()
                case (.regular, .compact):
                    self.transitionToCompact()
                case (.regular, .regular):
                    break
                case (.compact, .compact):
                    break
                default:
                    break
                }
            },
            completion: nil)
    }

    // MARK: - Rotation

    /// NOTE: this is called after(?) `willTransition(to: UITraitCollection, with: UIViewControllerTransitionCoordinator)` when both are called
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // PagedImageView
        // For collection view rotation see also: https://stackoverflow.com/a/43322706
        self.pagedImageView.beginRotation()
        coordinator.animate(
            alongsideTransition: { [unowned self] (context) -> Void in
                // If we are changing size classes, this will already be the new size class
                if self.traitCollection.horizontalSizeClass == .regular {
                    // TODO: skip activation if we are transitioning between size classes since transitionToRegular() already handles this?
                    // TODO: move into method on ScrollablePadView?
                    if size.width > size.height {
                        NSLayoutConstraint.deactivate(self.rootView.portraitConstraints)
                        NSLayoutConstraint.activate(self.rootView.landscapeConstraints)
                    } else {
                        NSLayoutConstraint.deactivate(self.rootView.landscapeConstraints)
                        NSLayoutConstraint.activate(self.rootView.portraitConstraints)
                    }
                }
                self.pagedImageView.layoutIfNeeded()
            },
            completion: { [unowned self] (context) -> Void in
                self.pagedImageView.completeRotation()
            }
        )
    }

    // MARK: - Utility

    /// Transition from regular to compact horizonal layout
    private func transitionToCompact() {
        rootView.deactivateRegularConstraints()
        NSLayoutConstraint.deactivate(sharedRegularConstraints)

        // Move pagedImageView
        pagedImageView.removeFromSuperview()
        rootView.scrollView.headerView = pagedImageView

        // activate constraints
        rootView.activateCompactConstraints()
    }

    /// Transition from compact to regular horizontal layout
    private func transitionToRegular() {
        rootView.deactivateCompactConstraints()

        // Move pagedImageView
        rootView.scrollView.removeHeaderView()
        rootView.insertSubview(pagedImageView, belowSubview: rootView.scrollView)

        // reset scrollView
        rootView.scrollView.headerHeight = 0

        rootView.activateRegularConstraints()
        NSLayoutConstraint.activate(sharedRegularConstraints)
    }
}

// MARK: - Layout
extension PadHistoryDetailViewController {

    override func viewWillLayoutSubviews() {
        if !initialSetupDone {
            switch traitCollection.horizontalSizeClass {
            case .compact:
                rootView.scrollView.headerView = pagedImageView
                rootView.activateCompactConstraints()
            case .regular:
                rootView.activateRegularConstraints()
                rootView.insertSubview(pagedImageView, belowSubview: rootView.scrollView)
                NSLayoutConstraint.activate(sharedRegularConstraints)
            default:
                log.error("Unexpected horizontalSizeClass: \(traitCollection.horizontalSizeClass)")
            }
            initialSetupDone = true
        }

        switch traitCollection.horizontalSizeClass {
        case .compact:
            rootView.scrollView.headerHeight = rootView.contentWidth + pagedImageView.pageControlHeight
        case .regular:
            rootView.scrollView.headerHeight = 0.0
        default:
            log.error("Unexpected horizontalSizeClass: \(traitCollection.horizontalSizeClass)")
        }
    }
}

// MARK: - PagedImageViewDelegate
extension PadHistoryDetailViewController: PagedImageViewDelegate {

    func displayFullScreenImage(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath) {
        // TODO: pass self or just pass pagedImageView as `animatingFrom`?
        delegate?.showImage(animatingFrom: self, dataSource: dataSource, indexPath: indexPath)
    }
}

// MARK: - ViewAnimatedTransitioning
extension PadHistoryDetailViewController: ViewAnimatedTransitioning {

    var originFrame: CGRect {
        return pagedImageView.originFrame
    }

    var originView: UIView {
        return pagedImageView.originView
    }

    func makeTransitioningView() -> UIView? {
        return pagedImageView.makeTransitioningView()
    }
}

// MARK: - AppSync
extension PadHistoryDetailViewController {
    func getDeal(withID id: GraphQLID) {
        viewState = .loading
        dataProvider.getDeal(withID: id)
            .then({ [weak self] deal in
                self?.viewState = .result(deal)
            }).catch({ [weak self] error in
                self?.viewState = .error(error)
            })
    }
}

// MARK: - ViewStateRenderable
extension PadHistoryDetailViewController: ViewStateRenderable {
    typealias ResultType = Deal

    func render(_ viewState: ViewState<ResultType>) {
        //stateView.render(viewState)
        switch viewState {
        case .empty:
            stateView.render(viewState)
            pagedImageView.isHidden = true
            rootView.scrollView.isHidden = true
        case .loading:
            stateView.render(viewState)
            pagedImageView.isHidden = true
            rootView.scrollView.isHidden = true
        case .result(let deal):
            // Update UI
            titleView.text = deal.title
            rootView.contentView.title = deal.title
            rootView.contentView.features = deal.features
            rootView.contentView.commentCount = deal.topic?.commentCount
            rootView.contentView.specifications = deal.specifications
            // images
            let safePhotoURLs = deal.photos
                .compactMap { URL(string: $0) }
                .compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)

            // FIXME:
            //apply(theme: AppTheme(theme: dealFragment.theme))
            UIView.animate(withDuration: 0.3, animations: {
                // FIXME: can't animate `isHidden`
                // see: https://stackoverflow.com/a/29080894
                self.stateView.render(viewState)
                self.pagedImageView.isHidden = false
                self.rootView.scrollView.isHidden = false
                //(self.themeManager.applyTheme >>> self.apply)(deal.theme)
            })
        case .error:
            stateView.render(viewState)
            pagedImageView.isHidden = true
            rootView.scrollView.isHidden = true
        }
    }
}

// MARK: - ThemeObserving
extension PadHistoryDetailViewController: ThemeObserving {
    func apply(theme: AppTheme) {
        // TODO: fix status bar themeing
        if themeManager.useDealTheme {
            apply(theme: ColorTheme(theme: dealFragment.theme))
            //apply(foreground: dealFragment.theme.foreground)
        } else {
            apply(theme: theme.baseTheme)
            if let foreground = theme.foreground {
                apply(foreground: foreground)
            }
        }
    }
}

// MARK: - Themeable
extension PadHistoryDetailViewController: Themeable {
    func apply(theme: ColorTheme) {
        // accentColor
        navigationController?.navigationBar.tintColor = theme.tint

        // backgroundColor
        navigationController?.view.backgroundColor = theme.systemBackground
        // NOTE: are not changing the following:
        //navigationController?.navigationBar.barTintColor = theme.backgroundColor
        //navigationController?.navigationBar.layoutIfNeeded() // Animate color change

        // Subviews
        titleView.apply(theme: theme)
        rootView.apply(theme: theme)
        pagedImageView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
extension PadHistoryDetailViewController: ForegroundThemeable {}
