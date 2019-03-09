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
    func showForum(with: Topic)
    func showImage(_: Promise<UIImage>, animatingFrom: CGRect)
}

// MARK: - View Controller

class HistoryDetailViewController: UIViewController {
    typealias Dependencies = HasDataProvider & HasThemeManager

    weak var delegate: HistoryDetailViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let themeManager: ThemeManagerType
    private var deal: Deal

    private var observationTokens: [ObservationToken] = []
    private var viewState: ViewState<Deal> {
        didSet {
            render(viewState)
        }
    }

    private let panGestureRecognizer = UIPanGestureRecognizer()
    /// TODO: rename `interactionController?
    private var transitionController: SlideTransitionController?

    // MARK: - Subviews

    private lazy var dismissButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .stop, target: self,
                               action: #selector(didPressDismiss(_:)))
    }()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let pagedImageView: PagedImageView = {
        let view = PagedImageView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        //label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let featuresText: MDTextView = {
        let label = MDTextView(stylesheet: Appearance.stylesheet)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.setTitle("Comments", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies, deal: Deal) {
        self.dataProvider = dependencies.dataProvider
        self.themeManager = dependencies.themeManager
        self.deal = deal
        self.viewState = .empty
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        //super.loadView()
        let view = UIView()

        view.addSubview(scrollView)
        scrollView.addSubview(pagedImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(featuresText)
        scrollView.addSubview(forumButton)
        navigationItem.leftBarButtonItem = dismissButton

        self.view = view
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

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
        forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        //storyButton.addTarget(self, action: #selector(didPressStory(_:)), for: .touchUpInside)

        viewState = .result(deal)
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        let spacing: CGFloat = 8.0
        let sideMargin: CGFloat = 16.0
        let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // scrollView
            scrollView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            // pagedImageView
            pagedImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            pagedImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacing),
            pagedImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor, constant: 32.0),
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            titleLabel.topAnchor.constraint(equalTo: pagedImageView.bottomAnchor, constant: spacing),
            titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            // featuresLabel
            featuresText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            featuresText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            featuresText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            // forumButton
            forumButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forumButton.topAnchor.constraint(equalTo: featuresText.bottomAnchor, constant: spacing),
            forumButton.widthAnchor.constraint(equalToConstant: 200.0),
            forumButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing)
        ])
    }

    private func setupObservations() -> [ObservationToken] {
        let themeToken = themeManager.addObserver(self)
        return [themeToken]
    }

    private func setupTransitionController() {
        transitionController = SlideTransitionController(transitionType: .panel, viewController: self)
        transitioningDelegate = transitionController
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
    // ...

    @objc private func didPressDismiss(_ sender: UIBarButtonItem) {
        delegate?.dismiss()
    }

}

// MARK: - ViewStateRenderable
extension HistoryDetailViewController: ViewStateRenderable {
    typealias ResultType = Deal

    func render(_ viewState: ViewState<Deal>) {
        switch viewState {
        case .empty:
            return
        case .error(let error):
            print("\(error.localizedDescription)")
        case .loading:
            return
        case .result(let deal):
            titleLabel.text = deal.title
            featuresText.markdown = deal.features
            // images
            let safePhotoURLs = deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            // forum
            renderComments(for: deal)
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
        if topic.commentCount > 0 {
            // TODO: display .commentCount + .replyCount?
            forumButton.setTitle("\(topic.commentCount) Comments", for: .normal)
        } else {
            forumButton.setTitle("Comments", for: .normal)
        }
    }

}

// MARK: - Themeable
extension HistoryDetailViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        //storyButton.backgroundColor = theme.accentColor
        forumButton.backgroundColor = theme.accentColor

        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        pagedImageView.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor
        featuresText.backgroundColor = theme.backgroundColor
        //storyButton.setTitleColor(theme.backgroundColor, for: .normal)
        forumButton.setTitleColor(theme.backgroundColor, for: .normal)

        // foreground
        /// TODO: set status bar and home indicator color?
        titleLabel.textColor = theme.foreground.textColor
        featuresText.textColor = theme.foreground.textColor

        // Subviews
        pagedImageView.apply(theme: theme)
    }
}
