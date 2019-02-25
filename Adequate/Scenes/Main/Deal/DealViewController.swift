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
    func showStory(with: Story)
    func showForum(with: Topic)
    func showSettings()
    func showHistoryList()
    //func controller(_ controller: DealViewController, shouldTransitionTo: MainScene)
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
    typealias Dependencies = HasMehService & HasThemeManager

    weak var delegate: DealViewControllerDelegate?

    private let mehService: MehServiceType
    private let themeManager: ThemeManagerType
    private var deal: Deal? = nil

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
        return UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self,
                               action: #selector(showHistory(_:)))
    }()

    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                     action: #selector(didPressShare(_:)))
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

    private let storyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Story", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    private let forumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Comments", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var footerButtonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [storyButton, forumButton, settingsButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 5.0
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
        self.mehService = dependencies.mehService
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
        scrollView.addSubview(footerButtonStackView)

        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)

        /// TODO: consolidate in dedicated UIView subclass
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(errorMessageLabel)
        view.addSubview(retryButton)

        view.addSubview(footerView)

        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItem = shareButton

        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getDeal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false

        pagedImageView.delegate = self
        footerView.delegate = self

        retryButton.addTarget(self, action: #selector(getDeal), for: .touchUpInside)
        forumButton.addTarget(self, action: #selector(showForum(_:)), for: .touchUpInside)
        storyButton.addTarget(self, action: #selector(showStory(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(showSettings(_:)), for: .touchUpInside)
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
            // footerButtonStackView
            footerButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footerButtonStackView.topAnchor.constraint(equalTo: featuresText.bottomAnchor, constant: spacing),
            footerButtonStackView.widthAnchor.constraint(equalToConstant: 200.0),
            footerButtonStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing)
        ])
    }

    // MARK: - Actions / Navigation

    @objc func getDeal() {
        render(.loading)
        mehService.getDeal().then({ [weak self] response in
            /// TODO: differentiate .result from .empty
            self?.deal = response.deal
            self?.render(.result(response))
        }).catch({ [weak self] error in
            print("Error: \(error)")
            self?.render(.error(error))
        })
    }

    @objc private func didPressShare(_ sender: UIBarButtonItem) {
        // TODO: is there a better way to handle this; should the button be disabled until we set the deal
        guard let deal = deal else { return }

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

    @objc private func showSettings(_ sender: UIBarButtonItem) {
        delegate?.showSettings()
    }

    @objc private func showImage(_ sender: Any) {
        //delegate?.showImage()
    }

    @objc private func showForum(_ sender: UIButton) {
        guard let deal = deal, let topic = deal.topic else {
            return
        }
        delegate?.showForum(with: topic)
    }

    @objc private func showStory(_ sender: UIButton) {
        guard let deal = deal else {
            return
        }
        delegate?.showStory(with: deal.story)
    }

    // @objc private func didPressHistory(_ sender: UIBarButtonItem) {
    @objc private func showHistory(_ sender: UIBarButtonItem) {
        delegate?.showHistoryList()
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
        guard let deal = deal else {
            return
        }
        delegate?.showPurchase(for: deal)
    }

}

// MARK: - ViewState
extension DealViewController {

    func render(_ viewState: ViewState<MehResponse>) {
        switch viewState {
        case .empty:
            activityIndicator.stopAnimating()
            messageLabel.text = "There was no data"
            errorMessageLabel.isHidden = true
            retryButton.isHidden = false
            scrollView.isHidden = true
        case .error(let error):
            activityIndicator.stopAnimating()
            /// TODO: display error message on messageLabel?
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
        case .result(let result):
            // Update UI
            shareButton.isEnabled = true
            titleLabel.text = result.deal.title
            featuresText.markdown = result.deal.features
            // images
            let safePhotoURLs = result.deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            // forum
            renderComments(for: result.deal)
            // footerView
            footerView.update(withDeal: result.deal)

            UIView.animate(withDuration: 0.3, animations: {
                self.activityIndicator.stopAnimating()
                self.messageLabel.isHidden = true
                self.errorMessageLabel.isHidden = true
                self.retryButton.isHidden = true
                self.scrollView.isHidden = false
                (self.themeManager.applyTheme >>> self.apply)(result.deal.theme)
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
            /// TODO: display .commentCount + .replyCount?
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
        storyButton.backgroundColor = theme.accentColor
        forumButton.backgroundColor = theme.accentColor

        // backgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.backgroundColor
        view.backgroundColor = theme.backgroundColor
        pagedImageView.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor
        featuresText.backgroundColor = theme.backgroundColor
        storyButton.setTitleColor(theme.backgroundColor, for: .normal)
        forumButton.setTitleColor(theme.backgroundColor, for: .normal)

        // foreground
        /// TODO: set status bar and home indicator color?
        titleLabel.textColor = theme.foreground.textColor
        featuresText.textColor = theme.foreground.textColor

        // Subviews
        pagedImageView.apply(theme: theme)
        footerView.apply(theme: theme)
    }
}
