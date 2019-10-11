//
//  DealViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class DealViewController: UIViewController {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager

    weak var delegate: DealViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let imageService: ImageServiceType
    private let themeManager: ThemeManagerType
    private let selectionFeedback = UISelectionFeedbackGenerator()

    private var observationTokens: [ObservationToken] = []
    private var viewState: ViewState<Deal> = .empty {
        didSet {
            render(viewState)
        }
    }

    // MARK: - Subviews

    private lazy var stateView: StateView = {
        let view = StateView()
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDeal()
        }
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

    private let scrollView: ParallaxScrollView = {
        let view = ParallaxScrollView()
        view.contentInsetAdjustmentBehavior = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let contentView: DealContentView = {
        let view = DealContentView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let barBackingView: ParallaxBarView = {
        let view = ParallaxBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pagedImageView: PagedImageView = {
        let view = PagedImageView(imageService: self.imageService)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Footer

    private lazy var footerView: FooterView = {
        let view = FooterView()
        //view.backgroundColor = view.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    override func loadView() {
        super.loadView()
        view.addSubview(stateView)
        view.addSubview(scrollView)
        view.addSubview(barBackingView)
        scrollView.headerView = pagedImageView
        scrollView.addSubview(contentView)
        view.addSubview(footerView)
        // Navigation bar
        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItems = [storyButton, shareButton]

        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observationTokens = setupObservations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TODO: remove now that we use PadDealViewController on iPad?
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let currentPage = pagedImageView.primaryVisiblePage
        let parallaxHeight: CGFloat = size.width + pagedImageView.pageControlHeight
        coordinator.animate(
            alongsideTransition: { [weak self] (context) -> Void in
                self?.pagedImageView.beginRotation()
            },
            completion: { [weak self] (context) -> Void in
                self?.pagedImageView.completeRotation(page: currentPage)
                self?.scrollView.headerHeight = parallaxHeight
            }
        )
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        navigationController?.applyStyle(.transparent)
        pagedImageView.delegate = self
        footerView.delegate = self

        contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
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

        // scrollView
        let parallaxHeight: CGFloat = view.frame.width + pagedImageView.pageControlHeight
        scrollView.headerHeight = parallaxHeight

        scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // stateView
            stateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: AppTheme.sideMargin),
            stateView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -AppTheme.sideMargin),
            // footerView
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // barBackingView
            barBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor),
            // scrollView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            // contentView
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func setupObservations() -> [ObservationToken] {
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

// MARK: - PagedImageViewDelegate
extension DealViewController: PagedImageViewDelegate {

    func displayFullscreenImage(animatingFrom pagedImageView: PagedImageView) {
        delegate?.showImage(animatingFrom: pagedImageView)
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
            scrollView.isHidden = true
            footerView.isHidden = true
        case .loading:
            stateView.render(viewState)
            scrollView.isHidden = true
            footerView.isHidden = true
            shareButton.isEnabled = false
            storyButton.isEnabled = false
        case .result(let deal):
            shareButton.isEnabled = true
            storyButton.isEnabled = true
            barBackingView.text = deal.title
            contentView.title = deal.title
            contentView.features = deal.features
            contentView.commentCount = deal.topic?.commentCount
            contentView.specifications = deal.specifications
            // images
            let safePhotoURLs = deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            // footerView
            footerView.update(withDeal: deal)

            themeManager.applyTheme(theme: deal.theme)
            UIView.animate(withDuration: 0.3, animations: {
                self.stateView.render(viewState)
                // FIXME: can't animate `isHidden`
                // see: https://stackoverflow.com/a/29080894
                self.scrollView.isHidden = false
                self.footerView.isHidden = false
                //(self.themeManager.applyTheme >>> self.apply)(deal.theme)
            })
        case .error:
            stateView.render(viewState)
            scrollView.isHidden = true
        }
    }
}

// MARK: - Themeable
extension DealViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        historyButton.tintColor = theme.accentColor
        shareButton.tintColor = theme.accentColor
        storyButton.tintColor = theme.accentColor

        // backgroundColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        navigationController?.navigationBar.layoutIfNeeded() // Animate color change
        view.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor

        // foreground
        // TODO: set home indicator color?
        navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        setNeedsStatusBarAppearanceUpdate()

        // Subviews
        pagedImageView.apply(theme: theme)
        contentView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
        footerView.apply(theme: theme)
    }
}
