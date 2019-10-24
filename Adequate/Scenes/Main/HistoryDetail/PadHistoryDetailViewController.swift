//
//  PadHistoryDetailViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/18/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class PadHistoryDetailViewController: UIViewController, SwipeDismissable {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager
    typealias DealFragment = ListDealsForPeriodQuery.Data.ListDealsForPeriod
    typealias Deal = GetDealQuery.Data.GetDeal
    typealias Topic = GetDealQuery.Data.GetDeal.Topic
    typealias GraphQLID = String

    weak var delegate: HistoryDetailViewControllerDelegate?

    var shouldDismiss: Bool {
        return scrollView.contentOffset.y <= 0
    }

    // TODO: rename `interactionController?
    //var transitionController: SlideTransitionController?
    var transitionController: UIViewControllerTransitioningDelegate?

    private let dataProvider: DataProviderType
    private let imageService: ImageServiceType
    private let themeManager: ThemeManagerType
    private var dealFragment: DealFragment

    //private var observationTokens: [ObservationToken] = []
    private var viewState: ViewState<Deal> = .empty {
        didSet {
            render(viewState)
        }
    }

    // MARK: Constraints

    private var compactConstraints: [NSLayoutConstraint] = []

    // iPad
    private var haveSetupRegularConstraints: Bool = false
    private lazy var regularPagedImageViewGuide = UILayoutGuide()
    private var sharedRegularConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []

    // Dimensions for pagedImageView
    private let pagedImageViewMargin: CGFloat = 8.0                     // Rename `pagedImageViewInset`?
    private let portraitWidthMultiplier: CGFloat = 1.0 / 2.0
    private let landscapeWidthMultiplier: CGFloat = 2.0 / 3.0

    /// The new size to which the view is transitioning.
    //private var newSize: CGSize?

    // MARK: - Subviews

    private lazy var stateView: StateView = {
        let view = StateView()
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDeal(withID: strongSelf.dealFragment.id)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Navigation Bar

    private lazy var dismissButton: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "CloseNavBar"), style: .plain, target: self, action: #selector(didPressDismiss(_:)))
    }()

    // Secondary Column

    private let scrollView: ParallaxScrollView = {
        let view = ParallaxScrollView()
        view.contentInsetAdjustmentBehavior = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorCompatibility.systemBackground
        return view
    }()

    private let contentView: DealContentView = {
        let view = DealContentView()
        view.backgroundColor = ColorCompatibility.systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var barBackingView: ParallaxBarView = {
        let view = ParallaxBarView()
        view.rightLabelInset = AppTheme.sideMargin
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

    override func loadView() {
        super.loadView()
        view.addSubview(stateView)
        view.addSubview(scrollView)
        view.addSubview(barBackingView)
        scrollView.addSubview(contentView)
        // Navigation bar
        navigationItem.leftBarButtonItem = dismissButton

        // Constraints
        setupConstraints()
        switch traitCollection.horizontalSizeClass {
        case .compact:
            setupParallaxScrollView()
        case .regular:
            // TODO: move into `setupRegularView()` method?
            barBackingView.leftLabelInset = AppTheme.sideMargin
            view.addSubview(pagedImageView)
            setupRegularConstraints()
        case .unspecified:
            log.error("Unspecified horizontalSizeClass")
        @unknown default:
            fatalError("Unrecognized size class: \(traitCollection.horizontalSizeClass)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //observationTokens = setupObservations()
        getDeal(withID: dealFragment.id)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure correct navigation bar style after aborted dismissal
        // FIXME: update this to work with new theme system
        navigationController?.navigationBar.barStyle = dealFragment.theme.foreground.navigationBarStyle
        setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    private func setupView() {
        navigationController?.applyStyle(.transparent)
        pagedImageView.delegate = self

        contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)

        // TODO: observe changes in themeManager.theme
        if themeManager.useDealTheme {
            apply(theme: ColorTheme(theme: dealFragment.theme))
        } else {
            apply(theme: themeManager.theme.baseTheme)
        }

        // barBackingView
        let statusBarHeight: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
        barBackingView.coordinateOffset = 8.0
        barBackingView.inset = statusBarHeight

        // scrollView
        scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }
    }

    // TODO: rename?
    private func setupParallaxScrollView() {
        scrollView.headerView = pagedImageView
        let parallaxHeight: CGFloat = view.frame.width + pagedImageView.pageControlHeight
        scrollView.headerHeight = parallaxHeight
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        // iPhone
        compactConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ]

        // Shared
        NSLayoutConstraint.activate([
            // stateView
            stateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -AppTheme.widthInset),
            // barBackingView
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor),
            barBackingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // contentView
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        if traitCollection.horizontalSizeClass == .compact {
            NSLayoutConstraint.activate(compactConstraints)
        }
    }

    private func setupRegularConstraints() {
        view.addLayoutGuide(regularPagedImageViewGuide)
        sharedRegularConstraints = [
            // regularPagedImageViewGuide
            regularPagedImageViewGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            regularPagedImageViewGuide.topAnchor.constraint(equalTo: view.topAnchor),
            regularPagedImageViewGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // pagedImageView
            // TODO: adjust constant on centerYAnchor to ensure placement below nav bar?
            pagedImageView.centerYAnchor.constraint(equalTo: regularPagedImageViewGuide.centerYAnchor, constant: 0.0),
            pagedImageView.centerXAnchor.constraint(equalTo: regularPagedImageViewGuide.centerXAnchor),
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor,
                                                   constant: pagedImageView.pageControlHeight),
            pagedImageView.widthAnchor.constraint(equalTo: regularPagedImageViewGuide.widthAnchor,
                                                  constant: -2.0 * pagedImageViewMargin),
            // scrollView
            scrollView.leadingAnchor.constraint(equalTo: regularPagedImageViewGuide.trailingAnchor)
        ]

        // Portrait
        let portraitMultiplier: CGFloat = 1.0 - portraitWidthMultiplier
        portraitConstraints = [
            regularPagedImageViewGuide.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: portraitWidthMultiplier),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: portraitMultiplier)
        ]

        // Landscape
        let landscapeMultiplier = 1.0 - landscapeWidthMultiplier
        landscapeConstraints = [
            regularPagedImageViewGuide.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: landscapeWidthMultiplier),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: landscapeMultiplier)
        ]

        haveSetupRegularConstraints = true

        // Activate
        if view.frame.width > view.frame.height {
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
        }
        NSLayoutConstraint.activate(sharedRegularConstraints)
    }
    /*
    private func setupObservations() -> [ObservationToken] {
        let themeToken = themeManager.addObserver(self)
        return [themeToken]
    }
    */

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

// MARK: - Transitions
extension PadHistoryDetailViewController {

    // MARK: Trait Collection

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        //guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        //guard traitCollection.horizontalSizeClass != newCollection.horizontalSizeClass else { return }

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

        //guard UIDevice.current.userInterfaceIdiom == .pad else { return }

        //newSize = size

        // PagedImageView
        // For collection view rotation see also: https://stackoverflow.com/a/43322706
        let currentPage = pagedImageView.primaryVisiblePage
        coordinator.animate(
            alongsideTransition: { [unowned self] (context) -> Void in
                // If we are changing size classes, this will already be the new size class
                if self.traitCollection.horizontalSizeClass == .regular {
                    // TODO: skip activation if we are transitioning between size classes since transitionToRegular() already handles this?
                    if size.width > size.height {
                        NSLayoutConstraint.deactivate(self.portraitConstraints)
                        NSLayoutConstraint.activate(self.landscapeConstraints)
                    } else {
                        NSLayoutConstraint.deactivate(self.landscapeConstraints)
                        NSLayoutConstraint.activate(self.portraitConstraints)
                    }
                } else if self.traitCollection.horizontalSizeClass == .compact {
                    self.scrollView.headerHeight = size.width + self.pagedImageView.pageControlHeight
                }
                //self.pagedImageView.alpha = 0.0
                self.pagedImageView.beginRotation()
            },
            completion: { [unowned self] (context) -> Void in
                self.pagedImageView.completeRotation(page: currentPage)
                //self.newSize = nil
            }
        )
    }

    // MARK: - Utility

    /// Transition from iPad to iPhone layout
    private func transitionToCompact() {
        // TODO: pass `newWidth: CGFloat?`?
        // deactivate constraints
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
        NSLayoutConstraint.deactivate(sharedRegularConstraints)

        // remove pagedImageView
        pagedImageView.removeFromSuperview()

        // add PagedImageView
        scrollView.headerView = pagedImageView
        //let viewWidth = newSize?.width ?? view.frame.width
        //scrollView.headerHeight = viewWidth + pagedImageView.pageControlHeight

        // TODO: clarify meaning of this magic constant
        barBackingView.leftLabelInset = 56.0

        // activate constraints
        NSLayoutConstraint.activate(compactConstraints)
    }

    /// Transition from iPhone to iPad layout
    private func transitionToRegular() {
        // deactivate constraints
        NSLayoutConstraint.deactivate(compactConstraints)

        // remove pagedImageView
        scrollView.removeHeaderView()

        // add PagedImageView
        view.addSubview(pagedImageView)

        barBackingView.leftLabelInset = AppTheme.sideMargin

        // reset scrollView
        scrollView.headerHeight = 0

        guard haveSetupRegularConstraints else {
            setupRegularConstraints()
            // TODO: call `pagedImageView.flowLayout.invalidateLayout()`?
            return // since setupRegularConstraints() already activates constraints
        }

        // activate constraints
        if view.frame.width > view.frame.height {
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
        }
        NSLayoutConstraint.activate(sharedRegularConstraints)
        // IMPORTANT
        pagedImageView.flowLayout.invalidateLayout()
    }
}

// MARK: - PagedImageViewDelegate
extension PadHistoryDetailViewController: PagedImageViewDelegate {

    func displayFullscreenImage(animatingFrom pagedImageView: PagedImageView) {
        delegate?.showImage(animatingFrom: pagedImageView)
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
            scrollView.isHidden = true
        case .loading:
            stateView.render(viewState)
            pagedImageView.isHidden = true
            scrollView.isHidden = true
        case .result(let deal):
            // Update UI
            barBackingView.text = deal.title
            contentView.title = deal.title
            contentView.features = deal.features
            contentView.commentCount = deal.topic?.commentCount
            contentView.specifications = deal.specifications
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
                self.scrollView.isHidden = false
                //(self.themeManager.applyTheme >>> self.apply)(deal.theme)
            })
        case .error:
            stateView.render(viewState)
            pagedImageView.isHidden = true
            scrollView.isHidden = true
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

            //if let foreground = theme.foreground {
            //    apply(foreground: foreground)
            //}
        }
    }
}

// MARK: - Themeable
extension PadHistoryDetailViewController: Themeable {
    func apply(theme: ColorTheme) {
        // accentColor
        dismissButton.tintColor = theme.tint

        // backgroundColor
        navigationController?.view.backgroundColor = theme.systemBackground
        // NOTE: are not changing the following:
        //navigationController?.navigationBar.barTintColor = theme.backgroundColor
        //navigationController?.navigationBar.layoutIfNeeded() // Animate color change

        view.backgroundColor = theme.systemBackground
        scrollView.backgroundColor = theme.systemBackground

        // Subviews
        pagedImageView.apply(theme: theme)
        contentView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
//extension PadHistoryDetailViewController: ForegroundThemeable {}
