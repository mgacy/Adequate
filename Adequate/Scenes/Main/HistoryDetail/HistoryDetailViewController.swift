//
//  HistoryDetailViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class HistoryDetailViewController: UIViewController, SwipeDismissable {
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Navigation Bar

    private lazy var dismissButton: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "CloseNavBar"), style: .plain, target: self, action: #selector(didPressDismiss(_:)))
    }()

    // ScrollView

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

    override func loadView() {
        super.loadView()
        view.addSubview(stateView)
        view.addSubview(scrollView)
        view.addSubview(barBackingView)
        scrollView.headerView = pagedImageView
        scrollView.addSubview(contentView)
        // Navigation bar
        navigationItem.leftBarButtonItem = dismissButton

        setupConstraints()
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
        setupParallaxScrollView()
        // FIXME: switch between using baseTheme and dealFragment
        //apply(theme: AppTheme(theme: dealFragment.theme))
        apply(theme: themeManager.theme.baseTheme)
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

        // scrollView
        let parallaxHeight: CGFloat = view.frame.width + pagedImageView.pageControlHeight
        scrollView.headerHeight = parallaxHeight

        scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // stateView
            stateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: AppTheme.sideMargin),
            stateView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -AppTheme.sideMargin),
            // barBackingView
            barBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor),
            // scrollView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // contentView
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
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

// MARK: - PagedImageViewDelegate
extension HistoryDetailViewController: PagedImageViewDelegate {

    func displayFullscreenImage(animatingFrom pagedImageView: PagedImageView) {
        delegate?.showImage(animatingFrom: pagedImageView)
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
            scrollView.isHidden = true
        case .loading:
            //stateView.render(viewState)
            //stateView.isHidden = false
            scrollView.isHidden = true
        case .result(let deal):
            //stateView.render(viewState)
            //stateView.isHidden = true
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
            scrollView.isHidden = false
            // TODO: animate display
        case .error:
            //stateView.render(viewState)
            //stateView.isHidden = false
            scrollView.isHidden = true
        }
    }
}

// MARK: - ThemeObserving
extension HistoryDetailViewController: ThemeObserving {
    func apply(theme: AppTheme) {

        // foreground
        if let foreground = theme.foreground {
            // TODO: set home indicator color?
            navigationController?.navigationBar.barStyle = foreground.navigationBarStyle
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}

// MARK: - Themeable
extension HistoryDetailViewController: Themeable {
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
