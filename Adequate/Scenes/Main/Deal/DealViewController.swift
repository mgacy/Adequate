//
//  DealViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

final class DealViewController: BaseViewController<ScrollableView<DealContentView>> {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager

    weak var delegate: DealViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let imageService: ImageServiceType
    private let themeManager: ThemeManagerType
    private let selectionFeedback = UISelectionFeedbackGenerator()

    private var viewState: ViewState<Deal> = .empty {
        didSet {
            render(viewState)
            footerViewController.render(viewState)
        }
    }

    private var initialSetupDone = false

    // MARK: - Subviews

    private lazy var stateView: StateView = {
        let view = StateView()
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDeal()
        }
        view.preservesSuperviewLayoutMargins = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Navigation Bar

    private lazy var historyButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "HistoryNavBar"), style: .plain, target: self, action: #selector(didPressHistory(_:)))
        button.accessibilityLabel = L10n.Accessibility.historyButton
        return button
    }()

    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ShareNavBar"), style: .plain, target: self, action: #selector(didPressShare(_:)))
        button.isEnabled = false
        button.accessibilityLabel = L10n.Accessibility.shareButton
        return button
    }()

    private lazy var storyButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "StoryNavBar"), style: .plain, target: self, action: #selector(didPressStory(_:)))
        button.isEnabled = false
        button.accessibilityLabel = L10n.Accessibility.storyButton
        return button
    }()

    // ScrollView

    private let barBackingView: ParallaxBarView = {
        let view = ParallaxBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pagedImageView: PagedImageView = {
        let view = PagedImageView(imageService: self.imageService)
        view.backgroundColor = ColorCompatibility.systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Footer

    private lazy var footerViewController: FooterViewController = {
        let controller = FooterViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        return controller
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.dataProvider = dependencies.dataProvider
        self.imageService = dependencies.imageService
        self.themeManager = dependencies.themeManager
        //self.viewState = .empty
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    override func setupView() {
        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItems = [storyButton, shareButton]
        navigationController?.applyStyle(.transparent)

        // TODO: move to `setupSubViews()`?
        pagedImageView.delegate = self

        add(footerViewController)
        view.insertSubview(stateView, at: 0)
        view.addSubview(barBackingView)
        rootView.scrollView.headerView = pagedImageView

        rootView.contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        setupConstraints()
        setupParallaxScrollView()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ensureVisibleImageLoaded),
                                       name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func setupParallaxScrollView() {

        // barBackingView
        let statusBarHeight: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
        barBackingView.coordinateOffset = 8.0
        barBackingView.inset = statusBarHeight

        rootView.scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // stateView
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.topAnchor.constraint(equalTo: guide.topAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            // footerViewController
            footerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // barBackingView
            barBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor),
        ])
    }

    override func setupObservations() -> [ObservationToken] {
        let dealToken = dataProvider.addDealObserver(self) { vc, viewState in
            vc.viewState = viewState
        }
        let themeToken = themeManager.addObserver(self)
        return [dealToken, themeToken]
    }

    // MARK: - Actions / Navigation

    @objc func getDeal() {
        dataProvider.refreshDeal(for: .manual)
    }

    @objc private func didPressShare(_ sender: UIBarButtonItem) {
        guard case .result(let deal) = viewState else {
            return
        }
        shareDeal(title: deal.title, url: deal.url)
    }

    func shareDeal(title: String, url: URL) {
        log.debug("\(#function) ...")

        // TODO: add price to text?
        let text = "\(L10n.sharingActivityText): \(title)"

        // set up activity view controller
        let textToShare: [Any] = [ text, url ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

        present(activityViewController, animated: true, completion: nil)
    }

    @objc func ensureVisibleImageLoaded(){
        guard let imageViewState = pagedImageView.visibleImageState else {
            return
        }
        if case .error = imageViewState {
            pagedImageView.reloadVisibleImage()
        }
    }

    // MARK: - Navigation

    @objc private func didPressForum(_ sender: UIButton) {
        guard case .result(let deal) = viewState, let topic = deal.topic else {
            return
        }
        delegate?.showForum(with: topic)
    }

    @objc private func didPressHistory(_ sender: UIBarButtonItem) {
        delegate?.showHistoryList()
    }

    @objc private func didPressStory(_ sender: UIBarButtonItem) {
        delegate?.showStory()
    }

}

// MARK: - UIContentContainer
extension DealViewController {

    // TODO: remove now that we use PadDealViewController on iPad?
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let currentPage = pagedImageView.primaryVisiblePage
        //let parallaxHeight: CGFloat = size.width + pagedImageView.pageControlHeight
        coordinator.animate(
            alongsideTransition: { [weak self] (context) -> Void in
                self?.pagedImageView.beginRotation()
            },
            completion: { [weak self] (context) -> Void in
                self?.pagedImageView.completeRotation(page: currentPage)
                //self?.rootView.scrollView.headerHeight = parallaxHeight
            }
        )
    }
}

// MARK: - Layout
extension DealViewController {

    override func viewWillLayoutSubviews() {
        if !initialSetupDone {
            switch view.safeAreaInsets.bottom {
            case 0.0..<8.0:
                footerViewController.view.layoutMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
            case 8.0..<22.0:
                footerViewController.view.layoutMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 0.0, right: 16.0)
            case 22.0...40.0:
                footerViewController.view.layoutMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 0.0, right: 16.0)

                // Fix excessive bottom padding on iPhone X, etc.
                // TODO: will this cause accessability problems? Disable this behavior at a given text size?
                //footerView.insetsLayoutMarginsFromSafeArea = false
                //let new = view.safeAreaInsets.bottom - 8.0
                //footerViewController.view.layoutMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: new, right: 16.0)
            default:
                log.error("Unexpected bottom safe area inset")
                footerViewController.view.layoutMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
            }

            rootView.scrollView.headerHeight = view.contentWidth + pagedImageView.pageControlHeight

            // TODO: adjust barBackingView.inset?

            initialSetupDone = true
        }
    }

    override func viewDidLayoutSubviews() {
        let footerHeight = footerViewController.view.frame.size.height - view.safeAreaInsets.bottom
        rootView.scrollView.contentInset.bottom = footerHeight
    }
}

// MARK: - PagedImageViewDelegate
extension DealViewController: PagedImageViewDelegate {

    func displayFullScreenImage(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath) {
        delegate?.showImage(animatingFrom: self, dataSource: dataSource, indexPath: indexPath)
    }
}

// MARK: - ViewAnimatedTransitioning
extension DealViewController: ViewAnimatedTransitioning {

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

// MARK: - DealFooterDelegate
extension DealViewController: DealFooterDelegate {

    func buy() {
        guard case .result(let deal) = viewState else {
            return
        }
        selectionFeedback.prepare()
        selectionFeedback.selectionChanged()
        delegate?.showPurchase(for: deal)
    }
}

// MARK: - ViewStateRenderable
extension DealViewController: ViewStateRenderable {
    typealias ResultType = Deal

    func render(_ viewState: ViewState<ResultType>) {
        //stateView.render(viewState)
        switch viewState {
        case .empty:
            stateView.render(viewState)
            rootView.scrollView.isHidden = true
        case .loading:
            stateView.render(viewState)
            rootView.scrollView.isHidden = true
            shareButton.isEnabled = false
            storyButton.isEnabled = false
        case .result(let deal):
            shareButton.isEnabled = true
            storyButton.isEnabled = true
            barBackingView.text = deal.title
            rootView.contentView.title = deal.title
            rootView.contentView.features = deal.features
            rootView.contentView.commentCount = deal.topic?.commentCount
            rootView.contentView.specifications = deal.specifications
            // images
            let safePhotoURLs = deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)

            UIView.animate(withDuration: 0.3, animations: {
                self.stateView.render(viewState)
                // FIXME: can't animate `isHidden`
                // see: https://stackoverflow.com/a/29080894
                self.rootView.scrollView.isHidden = false
                //(self.themeManager.applyTheme >>> self.apply)(deal.theme)
            })
        case .error:
            stateView.render(viewState)
            rootView.scrollView.isHidden = true
        }
    }
}

// MARK: - ThemeObserving
extension DealViewController: ThemeObserving {
    func apply(theme: AppTheme) {
        apply(theme: theme.dealTheme ?? theme.baseTheme)
        if let foreground = theme.foreground {
            apply(foreground: foreground)
        }
    }
}

// MARK: - Themeable
extension DealViewController: Themeable {
    func apply(theme: ColorTheme) {
        // accentColor
        navigationController?.navigationBar.tintColor = theme.tint

        // backgroundColor
        //navigationController?.navigationBar.barTintColor = theme.systemBackground
        //navigationController?.navigationBar.layoutIfNeeded() // Animate color change

        // foreground
        // TODO: set home indicator color?
        //navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        //setNeedsStatusBarAppearanceUpdate()

        // Subviews
        rootView.apply(theme: theme)
        pagedImageView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
        footerViewController.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
extension DealViewController: ForegroundThemeable {}
