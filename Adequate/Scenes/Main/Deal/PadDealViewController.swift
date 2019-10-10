//
//  PadDealViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/23/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class PadDealViewController: UIViewController {
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

    // Secondary Column

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

    private lazy var barBackingView: ParallaxBarView = {
        let view = ParallaxBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // PagedImageView

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
        scrollView.addSubview(contentView)
        view.addSubview(footerView)
        // Navigation bar
        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItems = [storyButton, shareButton]

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
        observationTokens = setupObservations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    private func setupView() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true

        pagedImageView.delegate = self
        footerView.delegate = self

        contentView.forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)

        // barBackingView
        let statusBarHeight: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
        barBackingView.coordinateOffset = 8.0
        barBackingView.inset = statusBarHeight

        // scrollView
        scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ensureVisibleImageLoaded),
                                       name: UIApplication.willEnterForegroundNotification, object: nil)
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
            // footerView
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // barBackingView
            barBackingView.topAnchor.constraint(equalTo: view.topAnchor),
            barBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackingView.bottomAnchor.constraint(equalTo: guide.topAnchor),
            barBackingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            // contentView
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        if traitCollection.horizontalSizeClass == .compact {
            //print("ACTIVATE: compactConstraints")
            NSLayoutConstraint.activate(compactConstraints)
            //layout = .compact
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
            //print("ACTIVATE: landscapeConstraints")
            NSLayoutConstraint.activate(landscapeConstraints)
            //layout = .regularLandscape
        } else {
            //print("ACTIVATE: portraitConstraints")
            NSLayoutConstraint.activate(portraitConstraints)
            //layout = .regularPortrait
        }
        NSLayoutConstraint.activate(sharedRegularConstraints)
    }

    private func setupObservations() -> [ObservationToken] {
        let dealToken = dataProvider.addDealObserver(self) { vc, viewState in
            vc.viewState = viewState
        }
        let themeToken = themeManager.addObserver(self)
        return [dealToken, themeToken]
    }

    // MARK: - Transition

    /// The new size to which the view is transitioning.
    //private var newSize: CGSize?

    // MARK: Trait Collection

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //print("COLLECTION - willTransition\nFROM:\t\(traitCollection)\nTO:\t\t\(newCollection)\n")
        super.willTransition(to: newCollection, with: coordinator)

        //guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        //guard traitCollection.horizontalSizeClass != newCollection.horizontalSizeClass else { return }

        let oldCollection = traitCollection
        coordinator.animate(
            alongsideTransition: { [unowned self] context in
                switch (oldCollection.horizontalSizeClass, newCollection.horizontalSizeClass) {
                case (.compact, .regular):
                    //print("COLLECTION - compact -> regular")
                    self.transitionToRegular()
                case (.regular, .compact):
                    //print("COLLECTION - regular -> compact")
                    self.transitionToCompact()
                case (.regular, .regular):
                    //print("COLLECTION - regular -> regular")
                    break
                case (.compact, .compact):
                    //print("COLLECTION - compact -> compact")
                    break
                default:
                    //print("COLLECTION - OTHER - \(oldCollection) -> \(newCollection)")
                    break
                }
            },
            completion: { context in
                /*
                switch self.layout {
                case .compact:
                    print("COLLECTION - compact")
                    //self.scrollView.headerHeight = self.view.frame.width + self.pagedImageView.pageControlHeight
                case .regularPortrait:
                    print("COLLECTION - regularPortrait")
                case .regularLandscape:
                    print("COLLECTION - regularLandscape")
                case .unspecified:
                    print("COLLECTION - unspecified")
                }
                */
                return
            }
        )
    }

    // MARK: - Rotation

    /// NOTE: this is called after(?) `willTransition(to: UITraitCollection, with: UIViewControllerTransitionCoordinator)` when both are called
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //print("SIZE - willTransition\nFROM:\t\(view.frame.size)\nTO:\t\t\(size)\n")
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
                        //print("SIZE - ACTIVATE: landscapeConstraints")
                        NSLayoutConstraint.deactivate(self.portraitConstraints)
                        NSLayoutConstraint.activate(self.landscapeConstraints)
                    } else {
                        //print("SIZE - ACTIVATE: portraitConstraints")
                        NSLayoutConstraint.deactivate(self.landscapeConstraints)
                        NSLayoutConstraint.activate(self.portraitConstraints)
                    }
                } else if self.traitCollection.horizontalSizeClass == .compact {
                    self.scrollView.headerHeight = size.width + self.pagedImageView.pageControlHeight
                }
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
        //layout = .compact
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
            //layout = .regularLandscape
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
            //layout = .regularPortrait
        }
        NSLayoutConstraint.activate(sharedRegularConstraints)
        // IMPORTANT
        pagedImageView.flowLayout.invalidateLayout()
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
extension PadDealViewController: PagedImageViewDelegate {

    func displayFullscreenImage(animatingFrom pagedImageView: PagedImageView) {
        delegate?.showImage(animatingFrom: pagedImageView)
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
            scrollView.isHidden = true
            footerView.isHidden = true
        case .loading:
            stateView.render(viewState)
            pagedImageView.isHidden = true
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
                // FIXME: can't animate `isHidden`
                // see: https://stackoverflow.com/a/29080894
                self.stateView.render(viewState)
                self.pagedImageView.isHidden = false
                self.scrollView.isHidden = false
                self.footerView.isHidden = false
                //(self.themeManager.applyTheme >>> self.apply)(deal.theme)
            })
        case .error:
            stateView.render(viewState)
            pagedImageView.isHidden = true
            scrollView.isHidden = true
            // TODO: hide footerView as well?
        }
    }
}

// MARK: - Themeable
extension PadDealViewController: Themeable {
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
        // TODO: set status bar and home indicator color?
        // TODO: set activityIndicator color
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
