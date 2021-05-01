//
//  DealViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise
import Combine

// swiftlint:disable file_length

final class DealViewController: BaseViewController<ScrollableView<DealContentView>> {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager

    weak var delegate: DealViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let imageService: ImageServiceType
    private let themeManager: ThemeManagerType
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private var viewState: ViewState<Deal> {
        dataProvider.dealState
    }

    private var initialSetupDone = false

    // MARK: - Subviews

    private lazy var stateView: StateView = {
        let view = StateView(frame: UIScreen.main.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDeal()
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

    // Footer

    private lazy var footerViewController: FooterViewController = {
        let controller = FooterViewController()
        controller.buttonTapHandler = { [weak self] in
            self?.buy()
        }
        controller.view.directionalLayoutMargins = .init(top: 8.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        controller.view.preservesSuperviewLayoutMargins = true
        controller.view.translatesAutoresizingMaskIntoConstraints = false
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

    // MARK: - View Methods

    override func setupView() {
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItems = [storyButton, shareButton]
        StyleBook.NavigationItem.transparent.apply(to: navigationItem)

        add(footerViewController)
        view.addSubview(barBackingView)

        if case .phone = UIDevice.current.userInterfaceIdiom {
            setupForPhone()
        }

        dataProvider.dealPublisher
            .sink { [weak self] viewState in
                self?.render(viewState)
            }
            .store(in: &cancellables)

        themeManager.themePublisher
            .sink { [weak self] theme in
                self?.apply(theme: theme)
            }
            .store(in: &cancellables)

        rootView.contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        setupConstraints()
        setupParallaxScrollView()

        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.ensureVisibleImageLoaded()
            }
            .store(in: &cancellables)
    }

    private func setupParallaxScrollView() {
        if let navBar = navigationController?.navigationBar {
            barBackingView.coordinateOffset = navBar.convert(navBar.bounds, to: rootView.scrollView).minY
        }

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
            // footerViewController
            footerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // barBackingView
            barBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor)
        ])
    }

    // MARK: - Public Actions

    // This can also be called by the coordinator
    func shareDeal(title: String, url: URL) {
        // TODO: add price to text?
        let text = "\(L10n.sharingActivityText): \(title)"
        let textToShare: [Any] = [ text, url ]
        switch traitCollection.horizontalSizeClass {
        case .regular:
            delegate?.showShareSheet(activityItems: textToShare, from: shareButton)
        default:
            delegate?.showShareSheet(activityItems: textToShare, from: view)
        }
    }

    // MARK: - Private Actions

    @objc private func didPressShare(_ sender: UIBarButtonItem) {
        guard case .result(let deal) = viewState else {
            return
        }
        shareDeal(title: deal.title, url: deal.url)
    }

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

    @objc private func getDeal() {
        dataProvider.refreshDeal(for: .manual)
    }

    private func buy() {
        guard case .result(let deal) = viewState else {
            return
        }
        feedbackGenerator.impactOccurred()
        delegate?.showPurchase(for: deal)
    }

    private func ensureVisibleImageLoaded() {
        guard let imageViewState = pagedImageView.visibleImageState else {
            return
        }
        if case .error = imageViewState {
            pagedImageView.reloadVisibleImage()
        }
    }
}

// MARK: - Layout
extension DealViewController {

    override func viewWillLayoutSubviews() {
        if !initialSetupDone {
            // TODO: will this cause accessability problems? Disable this behavior at a given `UIContentSizeCategory`?
            // Add additional bottom padding on devices without home indicator.
            //let bottomInset: CGFloat = view.safeAreaInsets.bottom > 8.0 ? 0.0 : 8.0
            switch view.safeAreaInsets.bottom {
            case 0.0..<8.0:
                footerViewController.view.directionalLayoutMargins = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
            case 8.0..<22.0: // iPad Pro (11", 12.9"): 20.0; iPhone X, etc. (Landscape): 21.0
                footerViewController.view.directionalLayoutMargins = .init(top: 8, leading: 0, bottom: 0, trailing: 0)
            case 22.0...40.0: // iPhone X, etc. (Portrait): 34.0
                footerViewController.view.directionalLayoutMargins = .init(top: 8, leading: 0, bottom: 0, trailing: 0)
                //footerViewController.view.insetsLayoutMarginsFromSafeArea = false
                //let new = view.safeAreaInsets.bottom - 8.0
                //footerViewController.view.directionalLayoutMargins = .init(top: 8, left: 0, bottom: new, right: 0)
            default:
                log.error("Unexpected bottom safe area inset")
                footerViewController.view.directionalLayoutMargins = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
            }

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
        // TODO: is this still needed with our override of `viewWillTransition(to:with:)`?
        guard case .pad = UIDevice.current.userInterfaceIdiom,
              case .compact = traitCollection.horizontalSizeClass else {
            return
        }
        rootView.scrollView.headerHeight = rootView.contentWidth + pagedImageView.pageControlHeight
    }

    override func viewDidLayoutSubviews() {
        // We use this to update insets when text size changes; move to traitCollectionDidChange()
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

// MARK: - ViewStateRenderable
extension DealViewController: ViewStateRenderable {
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
            shareButton.isEnabled = false
            storyButton.isEnabled = false
        case .result(let deal):
            shareButton.isEnabled = true
            storyButton.isEnabled = true
            titleView.text = deal.title
            rootView.contentView.title = deal.title
            rootView.contentView.features = deal.features
            rootView.contentView.commentCount = deal.topic?.commentCount
            rootView.contentView.specifications = deal.specifications
            // images
            let safePhotoURLs = deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            stateView.render(viewState)
            pagedImageView.isHidden = false
            rootView.scrollView.isHidden = false
        case .error:
            stateView.render(viewState)
            pagedImageView.isHidden = true
            rootView.scrollView.isHidden = true
        }
        footerViewController.render(viewState)
    }
}

// MARK: - ThemeObserving
extension DealViewController: ThemeObserving {
    func apply(theme: AppTheme) {
        apply(theme: theme.dealTheme ?? theme.baseTheme)
        //if let foreground = theme.foreground {
        //    apply(foreground: foreground)
        //}
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
        titleView.apply(theme: theme)
        rootView.apply(theme: theme)
        pagedImageView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
        footerViewController.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
//extension DealViewController: ForegroundThemeable {}

// MARK: - UIContentContainer
extension DealViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                if case .compact = self?.traitCollection.horizontalSizeClass, let rootView = self?.rootView {
                    let margins = rootView.directionalLayoutMargins.leading + rootView.directionalLayoutMargins.trailing
                    let pageControlHeight = self?.pagedImageView.pageControlHeight ?? 0.0
                    rootView.scrollView.headerHeight = size.width + pageControlHeight - margins
                }
            },
            completion: nil
        )
    }
}

// MARK: - PrimaryViewControllerType
extension DealViewController: PrimaryViewControllerType {

    func makeBackgroundView() -> UIView? {
        return stateView
    }

    //func makeSecondaryView() -> UIView? {
    //    return pagedImageView
    //}

    func configureConstraints(with secondaryColumnGuide: UILayoutGuide, in parentView: UIView) -> [NSLayoutConstraint] {
        let horizontalMargin: CGFloat = 40.0 // 2 * `NSCollectionLayoutItem.contentInsets` in `PagedImageView`

        let topConstraint = pagedImageView.topAnchor.constraint(equalTo: secondaryColumnGuide.topAnchor)
        topConstraint.priority = UILayoutPriority(650)

        let widthConstraint = pagedImageView.widthAnchor.constraint(equalTo: secondaryColumnGuide.widthAnchor,
                                                                    constant: horizontalMargin)
        widthConstraint.priority = UILayoutPriority(750)

        return [
            pagedImageView.centerYAnchor.constraint(equalTo: secondaryColumnGuide.centerYAnchor),
            pagedImageView.centerXAnchor.constraint(equalTo: secondaryColumnGuide.centerXAnchor),
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor,
                                                   constant: pagedImageView.pageControlHeight - horizontalMargin),
            pagedImageView.topAnchor.constraint(greaterThanOrEqualTo: secondaryColumnGuide.topAnchor),
            pagedImageView.leadingAnchor.constraint(greaterThanOrEqualTo: parentView.leadingAnchor),
            topConstraint,
            widthConstraint
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

// MARK: - RotationManaging
extension DealViewController: RotationManaging {

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
