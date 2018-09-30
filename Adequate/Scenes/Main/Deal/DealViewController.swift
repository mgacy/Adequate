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
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "LOADING"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // ScrollView

    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    // ...

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

    // ...

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    func setupView() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(footerButtonStackView)

        /// TODO: consolidate in dedicated UIView subclass
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)

        storyButton.addTarget(self, action: #selector(showStory(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(showSettings(_:)), for: .touchUpInside)

        setupConstraints()
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        let spacing: CGFloat = 14.0
        let sideMargin: CGFloat = 14.0
        //let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: sideMargin),
            messageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -sideMargin),
            messageLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: messageLabel.topAnchor),
            // scrollView
            scrollView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            // footerButtonStackView
            footerButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footerButtonStackView.widthAnchor.constraint(equalToConstant: 200.0),
            footerButtonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -spacing)
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
            scrollView.isHidden = true
        case .error(let error):
            activityIndicator.stopAnimating()
            messageLabel.isHidden = true
            /// TODO: display error message on messageLabel?
            scrollView.isHidden = true
            displayError(error: error)
        case .loading:
            activityIndicator.startAnimating()
            messageLabel.text = "LOADING"
            messageLabel.isHidden = false
            scrollView.isHidden = true
        case .result(let result):
            activityIndicator.stopAnimating()
            messageLabel.isHidden = true
            scrollView.isHidden = false
            // Update UI
            // ...
        }
    }

}

// MARK: - Themeable
extension DealViewController: Themeable {
    func apply(theme: Theme) {
        // ...
    }
}
