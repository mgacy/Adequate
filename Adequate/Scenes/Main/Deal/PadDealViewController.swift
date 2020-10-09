//
//  PadDealViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/23/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

final class PadDealViewController: BaseViewController<ScrollablePadView<DealContentView>> {
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

    // MARK: Constraints

    private var sharedRegularConstraints: [NSLayoutConstraint] = []

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

    // Secondary Column

    private lazy var barBackingView: ParallaxBarView = {
        let view = ParallaxBarView()
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

    private func setupSubviews() {
        view.insertSubview(stateView, at: 0)
        view.addSubview(barBackingView)
        add(footerViewController)
        setupConstraints()
    }

    override func setupView() {
        setupSubviews()

        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItems = [storyButton, shareButton]
        navigationController?.applyStyle(.transparent)
        pagedImageView.delegate = self

        // TODO: set closure on DealContentView instead?
        rootView.contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)

        // barBackingView
        // FIXME: see https://stackoverflow.com/a/57023907/4472195
        //let statusBarHeight: CGFloat =  view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let statusBarHeight: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
        barBackingView.coordinateOffset = 8.0
        barBackingView.inset = statusBarHeight

        // scrollView
        rootView.scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ensureVisibleImageLoaded),
                                       name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        // Shared
        NSLayoutConstraint.activate([
            // stateView
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.topAnchor.constraint(equalTo: guide.topAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            // footerView
            footerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerViewController.view.widthAnchor.constraint(equalTo: rootView.scrollView.widthAnchor),
            // barBackingView
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor),
            barBackingView.widthAnchor.constraint(equalTo: rootView.scrollView.widthAnchor),
        ])

        sharedRegularConstraints = [
            // TODO: adjust constant on centerYAnchor to ensure placement below nav bar?
            pagedImageView.centerYAnchor.constraint(equalTo: rootView.secondaryColumnGuide.centerYAnchor, constant: 0.0),
            pagedImageView.centerXAnchor.constraint(equalTo: rootView.secondaryColumnGuide.centerXAnchor),
            pagedImageView.widthAnchor.constraint(equalTo: rootView.secondaryColumnGuide.widthAnchor),
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor,
                                                   constant: pagedImageView.pageControlHeight)
        ]
    }

    override func setupObservations() -> [ObservationToken] {
        let dealToken = dataProvider.addDealObserver(self) { vc, viewState in
            vc.viewState = viewState
        }
        let themeToken = themeManager.addObserver(self)
        return [dealToken, themeToken]
    }

    // MARK: - Actions

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
extension PadDealViewController {

    // MARK: Trait Collection

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        let oldCollection = traitCollection
        coordinator.animate(
            alongsideTransition: { [unowned self] context in
                switch (oldCollection.horizontalSizeClass, newCollection.horizontalSizeClass) {
                case (.compact, .regular):
                    // Address bug when app starts in split view
                    if oldCollection.userInterfaceLevel == .base && newCollection.userInterfaceLevel == .elevated {
                        return
                    }

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
            completion: nil
        )
    }

    // MARK: - Rotation

    /// NOTE: this is called after(?) `willTransition(to: UITraitCollection, with: UIViewControllerTransitionCoordinator)` when both are called
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // TODO: check that size != current size

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
                //} else if self.traitCollection.horizontalSizeClass == .compact {
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

        // TODO: clarify meaning of this magic constant
        barBackingView.leftLabelInset = 56.0

        // activate constraints
        rootView.activateCompactConstraints()
    }

    /// Transition from compact to regular horizontal layout
    private func transitionToRegular() {
        rootView.deactivateCompactConstraints()

        // Move pagedImageView
        rootView.scrollView.removeHeaderView()
        view.addSubview(pagedImageView)

        barBackingView.leftLabelInset = AppTheme.sideMargin

        // reset scrollView
        rootView.scrollView.headerHeight = 0

        rootView.activateRegularConstraints()
        NSLayoutConstraint.activate(sharedRegularConstraints)
    }
}

// MARK: - Layout
extension PadDealViewController {

    override func viewWillLayoutSubviews() {
        if !initialSetupDone {
            switch traitCollection.horizontalSizeClass {
            case .compact:
                rootView.scrollView.headerView = pagedImageView

                // TODO: clarify meaning of this magic constant
                barBackingView.leftLabelInset = 56.0

                rootView.activateCompactConstraints()
            case .regular:
                rootView.activateRegularConstraints()
                view.addSubview(pagedImageView)
                barBackingView.leftLabelInset = view.layoutMargins.left
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: move to initial setup and .traitCollectionDidChange(_:) with check for .preferredContentSizeCategory?
        let footerHeight = footerViewController.view.frame.size.height - view.safeAreaInsets.bottom
        rootView.scrollView.contentInset.bottom = footerHeight
    }

    // At least on iPad, this seems to be called before `.viewWillLayoutSubviews`
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        // FIXME: get values for margins from a central source; move into a type?
        let bottomLayoutMargin: CGFloat = view.safeAreaInsets.bottom > 8.0 ? 0.0 : 8.0
        footerViewController.view.layoutMargins = UIEdgeInsets(top: 8.0,
                                                left: view.layoutMargins.left,
                                                bottom: bottomLayoutMargin,
                                                right: view.layoutMargins.right)
    }
}

// MARK: - PagedImageViewDelegate
extension PadDealViewController: PagedImageViewDelegate {

    func displayFullScreenImage(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath) {
        delegate?.showImage(animatingFrom: self, dataSource: dataSource, indexPath: indexPath)
    }
}

// MARK: - ViewAnimatedTransitioning
extension PadDealViewController: ViewAnimatedTransitioning {

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
extension PadDealViewController: DealFooterDelegate {

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
extension PadDealViewController: ViewStateRenderable {
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
            barBackingView.text = deal.title
            rootView.contentView.title = deal.title
            rootView.contentView.features = deal.features
            rootView.contentView.commentCount = deal.topic?.commentCount
            rootView.contentView.specifications = deal.specifications
            // images
            let safePhotoURLs = deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)

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
extension PadDealViewController: ThemeObserving {
    func apply(theme: AppTheme) {
        apply(theme: theme.dealTheme ?? theme.baseTheme)
        //if let foreground = theme.foreground {
        //    apply(foreground: foreground)
        //}
    }
}

// MARK: - Themeable
extension PadDealViewController: Themeable {
    func apply(theme: ColorTheme) {
        // accentColor
        navigationController?.navigationBar.tintColor = theme.tint

        // backgroundColor
        // NOTE: are not changing the following:
        //navigationController?.navigationBar.barTintColor = theme.systemBackground
        //navigationController?.navigationBar.layoutIfNeeded() // Animate color change

        // Subviews
        rootView.apply(theme: theme)
        pagedImageView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
        footerViewController.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
//extension PadDealViewController: ForegroundThemeable {}
