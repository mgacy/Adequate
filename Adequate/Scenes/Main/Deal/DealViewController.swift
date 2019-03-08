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
    func showImage(_: Promise<UIImage>, animatingFrom: CGRect)
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
    typealias Dependencies = HasDataProvider & HasThemeManager

    weak var delegate: DealViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let themeManager: ThemeManagerType

    private var observationTokens: [ObservationToken] = []
    private var viewState: ViewState<Deal> = .empty {
        didSet {
            print("\(String(describing: self)) - \(viewState)")
            render(viewState)
        }
    }

    /// TODO: make part of a protocol
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
        label.text = "LOADING"
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
        button.setTitle("Retry", for: .normal)
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
        return UIBarButtonItem(image: #imageLiteral(resourceName: "HistoryNavBar"), style: .plain, target: self, action: #selector(didPressHistory(_:)))
    }()

    private lazy var shareButton: UIBarButtonItem = {
        //let button = UIBarButtonItem(barButtonSystemItem: .action, target: self,
        //                             action: #selector(didPressShare(_:)))
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ShareNavBar"), style: .plain, target: self, action: #selector(didPressShare(_:)))
        button.isEnabled = false
        return button
    }()

    private lazy var storyButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "StoryNavBar"), style: .plain, target: self, action: #selector(didPressStory(_:)))
        button.isEnabled = false
        return button
    }()

    // ScrollView

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

    private let forumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Comments", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
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
        //self.viewState = .empty
        self.dataProvider = dependencies.dataProvider
        self.themeManager = dependencies.themeManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view.addSubview(scrollView)
        scrollView.addSubview(pagedImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(featuresText)
        scrollView.addSubview(forumButton)

        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)

        /// TODO: consolidate in dedicated UIView subclass
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(errorMessageLabel)
        view.addSubview(retryButton)

        view.addSubview(footerView)

        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItems = [storyButton, shareButton]

        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observationTokens = setupObservations()
        getDeal()
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

        pagedImageView.delegate = self
        footerView.delegate = self

        retryButton.addTarget(self, action: #selector(getDeal), for: .touchUpInside)
        forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        let spacing: CGFloat = 8.0
        let sideMargin: CGFloat = 16.0
        let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.centerYAnchor),
            // messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: sideMargin),
            messageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -sideMargin),
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 4.0),
            // errorMessageLabel
            errorMessageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: sideMargin),
            errorMessageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -sideMargin),
            errorMessageLabel.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: spacing * -2.0),
            // retryButton
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: spacing),
            // footerView
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // scrollView
            scrollView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
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
        let dealToken = dataProvider.addDealObserver(self) { vc, viewState in
            vc.viewState = viewState
        }
        let themeToken = themeManager.addObserver(self) { vc, theme in
            vc.apply(theme: theme)
        }
        return [dealToken, themeToken]
    }

    // MARK: - Actions / Navigation

    @objc func getDeal() {
        dataProvider.getDeal()
    }

    @objc private func didPressShare(_ sender: UIBarButtonItem) {
        guard case .result(let deal) = viewState else { 
            return
        }

        let text = "Check out this deal: \(deal.title)"
        let url = deal.url
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

    func displayFullscreenImage(_ imageSource: Promise<UIImage>, animatingFrom originFrame: CGRect) {
        delegate?.showImage(imageSource, animatingFrom: originFrame)
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
            messageLabel.text = "There was no data"
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
            messageLabel.text = "LOADING"
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
            featuresText.markdown = deal.features
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
extension DealViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        UIApplication.shared.delegate?.window??.tintColor = theme.accentColor
        forumButton.backgroundColor = theme.accentColor

        // backgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.backgroundColor
        view.backgroundColor = theme.backgroundColor
        pagedImageView.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor
        featuresText.backgroundColor = theme.backgroundColor
        forumButton.setTitleColor(theme.backgroundColor, for: .normal)

        // foreground
        // TODO: set status bar and home indicator color?
        titleLabel.textColor = theme.foreground.textColor
        featuresText.textColor = theme.foreground.textColor

        // Subviews
        pagedImageView.apply(theme: theme)
        footerView.apply(theme: theme)
    }
}
