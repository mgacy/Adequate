//
//  HistoryDetailViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

final class HistoryDetailViewController: BaseViewController<ScrollableView<DealContentView>>, SwipeDismissable {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager
    typealias DealFragment = ListDealsForPeriodQuery.Data.ListDealsForPeriod
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

    private var viewState: ViewState<Deal> {
        didSet {
            render(viewState)
        }
    }

    // MARK: - Subviews

    private lazy var stateView: StateView = {
        let view = StateView()
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDeal(withID: strongSelf.dealFragment.id)
        }
        view.preservesSuperviewLayoutMargins = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Navigation Bar

    private lazy var dismissButton: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "CloseNavBar"), style: .plain, target: self, action: #selector(didPressDismiss(_:)))
    }()

    // ScrollView

    private let barBackingView: ParallaxBarView = {
        let view = ParallaxBarView()
        view.rightLabelInset = AppTheme.sideMargin
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    override func setupView() {
        navigationItem.leftBarButtonItem = dismissButton
        navigationController?.applyStyle(.transparent)

        pagedImageView.delegate = self

        view.insertSubview(stateView, at: 0)
        view.addSubview(barBackingView)
        rootView.scrollView.headerView = pagedImageView

        rootView.contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        setupConstraints()
        setupParallaxScrollView()

        // TODO: observe changes in themeManager.theme
        if themeManager.useDealTheme {
            apply(theme: ColorTheme(theme: dealFragment.theme))
        } else {
            apply(theme: themeManager.theme.baseTheme)
        }
    }

    private func setupParallaxScrollView() {

        // barBackingView
        if #available(iOS 13, *) {
            // ...
        } else {
            let statusBarHeight: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
            barBackingView.coordinateOffset = 8.0
            barBackingView.inset = statusBarHeight
        }

        rootView.scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // stateView
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.topAnchor.constraint(equalTo: guide.topAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            // barBackingView
            barBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor)
        ])
    }
    /*
    override func setupObservations() -> [ObservationToken] {
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
        rootView.scrollView.headerHeight = view.contentWidth + pagedImageView.pageControlHeight
        // TODO: adjust barBackingView.inset?
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        rootView.scrollView.headerHeight = size.width + pagedImageView.pageControlHeight
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
            rootView.scrollView.isHidden = true
        case .loading:
            //stateView.render(viewState)
            //stateView.isHidden = false
            rootView.scrollView.isHidden = true
        case .result(let deal):
            //stateView.render(viewState)
            //stateView.isHidden = true
            barBackingView.text = deal.title
            rootView.contentView.title = deal.title
            rootView.contentView.features = deal.features
            rootView.contentView.commentCount = deal.topic?.commentCount
            rootView.contentView.specifications = deal.specifications
            // images
            let safePhotoURLs = deal.photos
                .compactMap { URL(string: $0) }
                .compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            rootView.scrollView.isHidden = false
            // TODO: animate display
        case .error:
            //stateView.render(viewState)
            //stateView.isHidden = false
            rootView.scrollView.isHidden = true
        }
    }
}

// MARK: - ThemeObserving
extension HistoryDetailViewController: ThemeObserving {
    func apply(theme: AppTheme) {
        // TODO: fix status bar themeing
        if themeManager.useDealTheme {
            apply(theme: ColorTheme(theme: dealFragment.theme))
            //apply(foreground: dealFragment.theme.foreground)
        } else {
            apply(theme: theme.baseTheme)
        }
        // TODO: fix status bar
        //if let foreground = theme.foreground {
        //    apply(foreground: foreground)
        //}
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
        rootView.apply(theme: theme)
        pagedImageView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
//extension HistoryDetailViewController: ForegroundThemeable {}
