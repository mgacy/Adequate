//
//  HistoryDetailViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise
import typealias AWSAppSync.GraphQLID // = String

final class HistoryDetailViewController: BaseViewController<ScrollableView<DealContentView>> {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager
    typealias DealFragment = DealHistoryQuery.Data.DealHistory.Item
    typealias Deal = GetDealQuery.Data.GetDeal

    weak var delegate: HistoryDetailViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let imageService: ImageServiceType
    private let themeManager: ThemeManagerType
    private var dealFragment: DealFragment

    private var viewState: ViewState<Deal> {
        didSet {
            render(viewState)
        }
    }

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

    // ScrollView

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

    private lazy var pagedImageView: PagedImageView = {
        let view = PagedImageView(imageService: self.imageService)
        view.delegate = self
        view.backgroundColor = .systemBackground
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

    override func viewDidLoad() {
        super.viewDidLoad()
        getDeal(withID: dealFragment.id)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure correct navigation bar style after aborted dismissal
        if themeManager.useDealTheme {
            navigationController?.navigationBar.barStyle = dealFragment.theme.foreground.navigationBarStyle
            setNeedsStatusBarAppearanceUpdate()
        }

        // Fix sizing when displayed on iPad on iOS 13
        //let parallaxHeight: CGFloat = view.frame.width + pagedImageView.pageControlHeight
        //rootView.scrollView.headerHeight = parallaxHeight
    }

    // MARK: - View Methods

    override func setupView() {
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = dismissButton
        StyleBook.NavigationItem.transparent.apply(to: navigationItem)

        view.addSubview(barBackingView)

        if case .phone = UIDevice.current.userInterfaceIdiom {
            setupForPhone()
        }

        rootView.contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        setupConstraints()
        setupParallaxScrollView()
    }

    private func setupParallaxScrollView() {
        //if let navBar = navigationController?.navigationBar {
        //    barBackingView.coordinateOffset = navBar.convert(navBar.bounds, to: rootView.scrollView).minY
        //}

        rootView.scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }
    }

    private func setupForPhone() {
        view.insertSubview(stateView, at: 0)
        collapseSecondaryView(pagedImageView)
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            barBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor)
        ])
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
    /*
    @objc private func didPressStory(_ sender: UIButton) {
        guard case .result(let deal) = viewState, let topic = deal.topic else {
            return
        }
        delegate?.showStory(with: deal.story)
    }
    */
    @objc private func didPressDismiss(_ sender: UIBarButtonItem) {
        delegate?.dismiss()
    }

}

// MARK: - Layout
extension HistoryDetailViewController {

    override func viewWillLayoutSubviews() {
        if !initialSetupDone {
            switch traitCollection.horizontalSizeClass {
            case .compact:
                rootView.scrollView.headerHeight = rootView.contentWidth + pagedImageView.pageControlHeight
            case .regular:
                rootView.scrollView.headerHeight = 0.0
            default:
                log.error("Unexpected horizontalSizeClass: \(traitCollection.horizontalSizeClass)")
            }

            initialSetupDone = true
        }

        // Help animation during rotation on iPad
        // On iOS 14.2, `viewWillTransition(to:with:)` was being called with an inaccurate `size`
        guard case .pad = UIDevice.current.userInterfaceIdiom,
              case .compact = traitCollection.horizontalSizeClass else {
            return
        }
        rootView.scrollView.headerHeight = rootView.contentWidth + pagedImageView.pageControlHeight
    }
}

// MARK: - PagedImageViewDelegate
extension HistoryDetailViewController: PagedImageViewDelegate {

    func displayFullScreenImage(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath) {
        delegate?.showImage(animatingFrom: self, dataSource: dataSource, indexPath: indexPath)
    }
}

// MARK: - ViewAnimatedTransitioning
extension HistoryDetailViewController: ViewAnimatedTransitioning {

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
extension HistoryDetailViewController {
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
extension HistoryDetailViewController: ViewStateRenderable {
    typealias ResultType = Deal

    func render(_ viewState: ViewState<ResultType>) {
        stateView.render(viewState)
        switch viewState {
        case .empty:
            //stateView.render(viewState)
            //stateView.isHidden = false
            pagedImageView.isHidden = true
            rootView.scrollView.isHidden = true
        case .loading:
            //stateView.render(viewState)
            //stateView.isHidden = false
            pagedImageView.isHidden = true
            rootView.scrollView.isHidden = true
        case .result(let deal):
            //stateView.render(viewState)
            //stateView.isHidden = true
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
            pagedImageView.isHidden = false
            rootView.scrollView.isHidden = false
            // TODO: animate display
        case .error:
            //stateView.render(viewState)
            //stateView.isHidden = false
            pagedImageView.isHidden = true
            rootView.scrollView.isHidden = true
        }
    }
}

// MARK: - ThemeObserving
extension HistoryDetailViewController: ThemeObserving {
    func apply(theme: AppTheme) {
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
extension HistoryDetailViewController: Themeable {
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
extension HistoryDetailViewController: ForegroundThemeable {}

// MARK: - PrimaryViewControllerType
extension HistoryDetailViewController: PrimaryViewControllerType {

    func makeBackgroundView() -> UIView? {
        return stateView
    }

    //func makeSecondaryView() -> UIView? {
    //    return pagedImageView
    //}

    func configureConstraints(with secondaryColumnGuide: UILayoutGuide, in parentView: UIView) -> [NSLayoutConstraint] {
        let horizontalMargin: CGFloat = 40.0 // 2 * `NSCollectionLayoutItem.contentInsets` in `PagedImageView`
        return [
            pagedImageView.centerYAnchor.constraint(equalTo: secondaryColumnGuide.centerYAnchor),
            pagedImageView.centerXAnchor.constraint(equalTo: secondaryColumnGuide.centerXAnchor),
            pagedImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor,
                                                   constant: pagedImageView.pageControlHeight - horizontalMargin)
        ]
    }

    func collapseSecondaryView(_ secondaryView: UIView) {
        rootView.scrollView.headerView = secondaryView
        //rootView.scrollView.headerHeight = view.contentWidth + pagedImageView.pageControlHeight // ?
    }

    func separateSecondaryView() -> UIView? {
        rootView.scrollView.removeHeaderView()
        rootView.scrollView.headerHeight = 0
        // Return `pagedImageView` directly, rather than the result of `ParallaxScrollView.removeHeaderView()`, so
        // `SplitViewController` can call this method during initial configuration without requiring that we
        // needlessly add it to the scroll view.
        return pagedImageView
    }
}

extension HistoryDetailViewController: RotationManaging {

    func beforeRotation() {
        pagedImageView.beginRotation()
    }

    func alongsideRotation(_ context: UIViewControllerTransitionCoordinatorContext) {
        pagedImageView.layoutIfNeeded()
    }

    func completeRotation(_ context: UIViewControllerTransitionCoordinatorContext) {
        pagedImageView.completeRotation()
    }
}
