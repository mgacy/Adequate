//
//  StoryViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/30/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Down

// MARK: - Delegate

protocol StoryViewControllerDelegate: class {
    func showDeal()
}

// MARK: - View Controller

final class StoryViewController: UIViewController {
    typealias Dependencies = HasThemeManager

    var viewState: ViewState<Story> {
        didSet {
            render(viewState)
        }
    }

    weak var delegate: StoryViewControllerDelegate?

    private let themeManager: ThemeManagerType

    // MARK: - Subviews

    private lazy var dealButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "LeftChevronNavBar"), style: .plain, target: self, action: #selector(didPressDeal(_:)))
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyText: MDTextView = {
        let view = MDTextView(stylesheet: Appearance.stylesheet)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, bodyText])
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(depenedencies: Dependencies) {
        self.viewState = .empty
        self.themeManager = depenedencies.themeManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        navigationItem.leftBarButtonItem = dealButton
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    */
    // MARK: - View Methods

    private func setupView() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white

        render(viewState)

        if let theme = themeManager.theme {
            apply(theme: theme)
        }
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        //let spacing: CGFloat = 16.0
        let sideMargin: CGFloat = 16.0
        let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // scrollView
            scrollView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    // MARK: - Navigation

    @objc private func didPressDeal(_ sender: UIBarButtonItem) {
        delegate?.showDeal()
    }

}

// MARK: - ViewState
extension StoryViewController {
    func render(_ viewState: ViewState<Story>) {
        switch viewState {
        case .empty:
            print("EMPTY")
        case .loading:
            print("LOADING ...")
        case .result(let story):
            titleLabel.text = story.title
            bodyText.markdown = story.body
        case .error(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Themeable
extension StoryViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        // ...

        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        bodyText.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor

        // foreground
        titleLabel.textColor = theme.foreground.textColor
        bodyText.textColor = theme.foreground.textColor
    }
}
