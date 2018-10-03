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
    func showWebPage(with: URL)
    func showImage(with: Promise<UIImage>)
    func showPurchase(for: Deal)
    func showStory(with: Story)
    func showForum(_: URL)
    func showSettings()
    //func controllerDidPressSettings(_ controller: DealViewController)
    //func controller(_ controller: DealViewController, shouldTransitionTo: MainScene)
}

//protocol MainSceneDelegate: class {
//    func controller(_ controller: DealViewController, shouldTransitionTo: MainScene)
//}

// MARK: - View Controller

class DealViewController: UIViewController {

    weak var delegate: DealViewControllerDelegate?

    private let mehService: MehServiceType
    private var deal: Deal? = nil

    // MARK: - Interface

    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.text = "LOADING"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Retry", for: .normal)
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    // ScrollView

    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private var pagedImageView: PagedImageView = {
        let view = PagedImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var featuresText: MDTextView = {
        let label = MDTextView(stylesheet: Appearance.stylesheet)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var storyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Story", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    private var forumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Comments", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    private var settingsButton: UIButton = {
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
        view.backgroundColor = view.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    typealias Dependencies = HasMehService

    init(dependencies: Dependencies) {
        self.mehService = dependencies.mehService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getDeal()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    func setupView() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(pagedImageView)
        //pagedImageView.delegate = self
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(featuresText)
        scrollView.addSubview(footerButtonStackView)

        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)

        /// TODO: consolidate in dedicated UIView subclass
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(retryButton)

        view.addSubview(footerView)
        footerView.delegate = self

        retryButton.addTarget(self, action: #selector(getDeal), for: .touchUpInside)
        forumButton.addTarget(self, action: #selector(showForum(_:)), for: .touchUpInside)
        storyButton.addTarget(self, action: #selector(showStory(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(showSettings(_:)), for: .touchUpInside)

        setupConstraints()
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        let spacing: CGFloat = 14.0
        let sideMargin: CGFloat = 14.0
        let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: sideMargin),
            messageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -sideMargin),
            messageLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: messageLabel.topAnchor),
            // retryButton
            retryButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: spacing),
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
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor),
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
        delegate?.showWebPage(with: topic.url)
    }

    @objc private func showStory(_ sender: UIButton) {
        guard let deal = deal else {
            return
        }
        delegate?.showStory(with: deal.story)
    }

}

// MARK: - ViewState
extension DealViewController {

    func render(_ viewState: ViewState<MehResponse>) {
        switch viewState {
        case .empty:
            activityIndicator.stopAnimating()
            messageLabel.text = "There was no data"
            retryButton.isHidden = false
            scrollView.isHidden = true
        case .error(let error):
            activityIndicator.stopAnimating()
            /// TODO: display error message on messageLabel?
            messageLabel.isHidden = true
            retryButton.isHidden = false
            scrollView.isHidden = true
            displayError(error: error)
        case .loading:
            activityIndicator.startAnimating()
            messageLabel.text = "LOADING"
            messageLabel.isHidden = false
            retryButton.isHidden = true
            scrollView.isHidden = true
        case .result(let result):
            activityIndicator.stopAnimating()
            messageLabel.isHidden = true
            retryButton.isHidden = true
            scrollView.isHidden = false
            // Update UI
            apply(theme: result.deal.theme)
            titleLabel.text = result.deal.title
            // images
            let safePhotoURLs = result.deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
            // features
            featuresText.markdown = result.deal.features
            // forum
            renderComments(for: result.deal)
            // footerView
            footerView.update(withDeal: result.deal)
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
    func apply(theme: Theme) {
        // accentColor
        let accentColor = UIColor(hexString: theme.accentColor)

        //let sharedApplication = UIApplication.shared
        UIApplication.shared.delegate?.window??.tintColor = accentColor

        storyButton.backgroundColor = accentColor
        forumButton.backgroundColor = accentColor

        // backgroundColor
        let backgroundColor = UIColor(hexString: theme.backgroundColor)
        view.backgroundColor = backgroundColor
        pagedImageView.backgroundColor = backgroundColor
        scrollView.backgroundColor = backgroundColor
        featuresText.backgroundColor = backgroundColor
        storyButton.setTitleColor(backgroundColor, for: .normal)
        forumButton.setTitleColor(backgroundColor, for: .normal)

        // foreground
        switch theme.foreground {
        case .dark:
            titleLabel.textColor = .black
            featuresText.textColor = .black
        case .light:
            titleLabel.textColor = .white
            featuresText.textColor = .white
        }

        // Subviews
        pagedImageView.apply(theme: theme)
        footerView.apply(theme: theme)
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
