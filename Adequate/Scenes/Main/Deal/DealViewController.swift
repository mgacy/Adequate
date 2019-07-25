//
//  DealViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

// MARK: - Delegate

protocol DealViewControllerDelegate: class {
    func showImage(animatingFrom: PagedImageView)
    func showPurchase(for: Deal)
    func showForum(with: Topic)
    func showHistoryList()
    func showStory()
}

//enum MainScene {
//    case forum(Topic)
//    case history
//    case image(Promise<UIImage>)
//    case purchase(Deal)
//    case story(Story)
//    case settings
//}
//
//protocol MainSceneDelegate: class {
//    func controller(_ controller: DealViewController, shouldTransitionTo: MainScene)
//}

// MARK: - View Controller

class DealViewController: UIViewController {
    typealias Dependencies = HasDataProvider & HasImageService & HasThemeManager

    weak var delegate: DealViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let imageService: ImageServiceType
    private let themeManager: ThemeManagerType

    private var observationTokens: [ObservationToken] = []
    private var viewState: ViewState<Deal> = .empty {
        didSet {
            render(viewState)
        }
    }

    // TODO: make part of a protocol
    var visibleImage: Promise<UIImage> {
        return pagedImageView.visibleImage
    }

    // MARK: - Subviews

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textColor = .gray
        label.text = L10n.loadingMessage
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(L10n.retry, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.backgroundColor = .clear
        button.setTitleColor(.gray, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        //label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let featuresText: MDTextView = {
        let view = MDTextView(stylesheet: Appearance.stylesheet)
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.paragraphStyle = .list
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let forumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(L10n.Comments.count(0), for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    private let specsText: MDTextView = {
        let stylesheet = """
        * { font: -apple-system-body; }
        h1, h2, h3, h4, h5, h6, strong { font-weight: bold; }
        em { font-style: italic; }
        h5 { font-style: italic; }
        """
        let view = MDTextView(stylesheet: stylesheet)
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.paragraphStyle = .list
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
        view.addSubview(scrollView)
        scrollView.headerView = pagedImageView
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(featuresText)
        contentView.addSubview(forumButton)
        contentView.addSubview(specsText)

        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)

        // TODO: consolidate in dedicated UIView subclass
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(errorMessageLabel)
        view.addSubview(retryButton)

        view.addSubview(barBackingView)
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let currentPage = pagedImageView.primaryVisiblePage
        coordinator.animate(
            alongsideTransition: { [weak self] (context) -> Void in
                self?.pagedImageView.beginRotation()
            },
            completion: { [weak self] (context) -> Void in
                self?.pagedImageView.completeRotation(page: currentPage)
            }
        )
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true

        pagedImageView.delegate = self
        footerView.delegate = self

        retryButton.addTarget(self, action: #selector(getDeal), for: .touchUpInside)
        forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        setupParallaxScrollView()
    }

    func setupParallaxScrollView() {

        // barBackingView
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
        barBackingView.coordinateOffset = 8.0
        barBackingView.inset = statusBarHeight

        // scrollView
        let parallaxHeight: CGFloat = view.frame.width + 24.0 // Add height of PagedImageView.pageControl
        scrollView.headerHeight = parallaxHeight

        scrollView.parallaxHeaderDidScrollHandler = { [weak barBackingView] scrollView in
            barBackingView?.updateProgress(yOffset: scrollView.contentOffset.y)
        }
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.centerYAnchor),
            // messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: AppTheme.sideMargin),
            messageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -AppTheme.sideMargin),
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 4.0),
            // errorMessageLabel
            errorMessageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: AppTheme.sideMargin),
            errorMessageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -AppTheme.sideMargin),
            errorMessageLabel.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: AppTheme.spacing * -2.0),
            // retryButton
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: AppTheme.spacing),
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
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppTheme.sideMargin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppTheme.spacing),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: AppTheme.widthInset),
            // featuresLabel
            featuresText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppTheme.sideMargin),
            featuresText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppTheme.spacing * 2.0),
            featuresText.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: AppTheme.widthInset),
            // forumButton
            forumButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forumButton.topAnchor.constraint(equalTo: featuresText.bottomAnchor, constant: AppTheme.spacing),
            forumButton.widthAnchor.constraint(equalToConstant: 200.0),
            // specsText
            specsText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppTheme.sideMargin),
            specsText.topAnchor.constraint(equalTo: forumButton.bottomAnchor, constant: AppTheme.spacing * 2.0),
            specsText.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: AppTheme.widthInset),
            specsText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppTheme.spacing)
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
        delegate?.showPurchase(for: deal)
    }
}

// MARK: - ViewStateRenderable
extension DealViewController: ViewStateRenderable {
    typealias ResultType = Deal

    func render(_ viewState: ViewState<Deal>) {
        switch viewState {
        case .empty:
            activityIndicator.stopAnimating()
            messageLabel.text = L10n.emptyMessage
            errorMessageLabel.isHidden = true
            retryButton.isHidden = false
            scrollView.isHidden = true
            footerView.isHidden = true
        case .error(let error):
            activityIndicator.stopAnimating()
            // TODO: display error message on messageLabel?
            messageLabel.isHidden = true
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = error.localizedDescription
            retryButton.isHidden = false
            scrollView.isHidden = true
            //displayError(error: error)
        case .loading:
            activityIndicator.startAnimating()
            messageLabel.text = L10n.loadingMessage
            messageLabel.isHidden = false
            errorMessageLabel.isHidden = true
            retryButton.isHidden = true
            scrollView.isHidden = true
            shareButton.isEnabled = false
            storyButton.isEnabled = false
        case .result(let deal):
            // Update UI
            shareButton.isEnabled = true
            storyButton.isEnabled = true
            titleLabel.text = deal.title
            barBackingView.text = deal.title
            featuresText.markdown = deal.features
            specsText.markdown = deal.specifications
            // images
            let safePhotoURLs = deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            // forum
            renderComments(for: deal)
            // footerView
            footerView.update(withDeal: deal)

            themeManager.applyTheme(theme: deal.theme)
            UIView.animate(withDuration: 0.3, animations: {
                self.activityIndicator.stopAnimating()
                self.messageLabel.isHidden = true
                self.errorMessageLabel.isHidden = true
                self.retryButton.isHidden = true
                self.scrollView.isHidden = false
                self.footerView.isHidden = false
                //(self.themeManager.applyTheme >>> self.apply)(deal.theme)
            })
        }
    }

    // MARK: Helper Methods

    // TODO: move into extension on Topic?
    private func renderComments(for deal: Deal) {
        guard let topic = deal.topic else {
            forumButton.isEnabled = false
            forumButton.isHidden = true
            return
        }
        forumButton.isHidden = false
        forumButton.isEnabled = true
        forumButton.setTitle(L10n.Comments.count(topic.commentCount), for: .normal)
    }

}

// MARK: - Themeable
extension DealViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        historyButton.tintColor = theme.accentColor
        shareButton.tintColor = theme.accentColor
        storyButton.tintColor = theme.accentColor
        forumButton.backgroundColor = theme.accentColor

        // backgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.backgroundColor
        self.navigationController?.navigationBar.layoutIfNeeded() // Animate color change
        view.backgroundColor = theme.backgroundColor
        pagedImageView.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        featuresText.backgroundColor = theme.backgroundColor
        forumButton.setTitleColor(theme.backgroundColor, for: .normal)
        specsText.backgroundColor = theme.backgroundColor

        // foreground
        // TODO: set status bar and home indicator color?
        // TODO: set activityIndicator color
        titleLabel.textColor = theme.foreground.textColor
        featuresText.textColor = theme.foreground.textColor
        specsText.textColor = theme.foreground.textColor
        navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        setNeedsStatusBarAppearanceUpdate()

        // Subviews
        pagedImageView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        footerView.apply(theme: theme)
    }
}
