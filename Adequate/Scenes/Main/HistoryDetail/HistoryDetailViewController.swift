//
//  HistoryDetailViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

// MARK: - Protocol

protocol HistoryDetailViewControllerDelegate: VoidDismissalDelegate {
    typealias Topic = GetDealQuery.Data.GetDeal.Topic
    func showForum(with: Topic)
    func showImage(animatingFrom: PagedImageView)
}

// MARK: - View Controller

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

    private lazy var dismissButton: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "CloseNavBar"), style: .plain, target: self, action: #selector(didPressDismiss(_:)))
    }()

    private lazy var stateView: StateView = {
        let view = StateView()
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDeal(withID: strongSelf.dealFragment.id)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollView: ParallaxScrollView = {
        let view = ParallaxScrollView()
        view.contentInsetAdjustmentBehavior = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
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
        label.font = FontBook.mainTitle
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let featuresText: MDTextView = {
        let styler = MDStyler()
        let view = MDTextView(styler: styler)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /*
    private let storyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Story", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()
    */
    private let forumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(L10n.Comments.count(0), for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    private let specsText: MDTextView = {
        let styler = MDStyler()
        let view = MDTextView(styler: styler)
        view.adjustsFontForContentSizeCategory = true
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(featuresText)
        contentView.addSubview(forumButton)
        contentView.addSubview(specsText)
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
        navigationController?.navigationBar.barStyle = dealFragment.theme.foreground.navigationBarStyle
        setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true

        pagedImageView.delegate = self

        forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        //storyButton.addTarget(self, action: #selector(didPressStory(_:)), for: .touchUpInside)
        setupParallaxScrollView()
        apply(theme: AppTheme(theme: dealFragment.theme))
    }

    func setupParallaxScrollView() {

        // barBackingView
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
        barBackingView.coordinateOffset = 8.0 // spacing
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
            //stateView.isHidden = false
            scrollView.isHidden = true
        case .loading:
            //stateView.isHidden = false
            scrollView.isHidden = true
        case .result(let deal):
            //stateView.isHidden = true
            barBackingView.text = deal.title
            titleLabel.text = deal.title
            featuresText.text = deal.features
            specsText.text = deal.specifications
            // images
            let safePhotoURLs = deal.photos
                .compactMap { URL(string: $0) }
                .compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            // forum
            renderComments(for: deal)
            scrollView.isHidden = false
        case .error:
            //stateView.isHidden = false
            scrollView.isHidden = true
        }
    }

    // MARK: Helper Methods

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
extension HistoryDetailViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        //storyButton.backgroundColor = theme.accentColor
        dismissButton.tintColor = theme.accentColor
        forumButton.backgroundColor = theme.accentColor

        // backgroundColor
        navigationController?.view.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        view.backgroundColor = theme.backgroundColor
        pagedImageView.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        featuresText.backgroundColor = theme.backgroundColor
        forumButton.setTitleColor(theme.backgroundColor, for: .normal)
        specsText.backgroundColor = theme.backgroundColor
        //storyButton.setTitleColor(theme.backgroundColor, for: .normal)

        // foreground
        // TODO: set home indicator color?
        titleLabel.textColor = theme.foreground.textColor
        featuresText.textColor = theme.foreground.textColor
        specsText.textColor = theme.foreground.textColor
        navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        setNeedsStatusBarAppearanceUpdate()

        // Subviews
        pagedImageView.apply(theme: theme)
        barBackingView.apply(theme: theme)
        stateView.apply(theme: theme)
    }
}
