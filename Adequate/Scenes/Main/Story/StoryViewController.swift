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
    typealias Dependencies = HasDataProvider & HasThemeManager

    weak var delegate: StoryViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let themeManager: ThemeManagerType

    private var observationTokens: [ObservationToken] = []
    private var viewState: ViewState<Deal> {
        didSet {
            render(viewState)
        }
    }

    // MARK: - Subviews

    private lazy var dealButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "LeftChevronNavBar"), style: .plain, target: self, action: #selector(didPressDeal(_:)))
        return button
    }()

    // TODO: add `StateView`?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontBook.mainTitle
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyText: MDTextView = {
        let styler = MDStyler()
        let view = MDTextView(styler: styler)
        view.adjustsFontForContentSizeCategory = true
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
        self.dataProvider = depenedencies.dataProvider
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

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    private func setupView() {
        title = L10n.story
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
        apply(theme: themeManager.theme)
        observationTokens = setupObservations()
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: AppTheme.sideMargin),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppTheme.spacing * 2.0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -AppTheme.sideMargin),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: AppTheme.spacing * -2.0),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: AppTheme.widthInset),
        ])
    }

    private func setupObservations() -> [ObservationToken] {
        let dealToken = dataProvider.addDealObserver(self) { vc, viewState in
            vc.viewState = viewState
        }
        let themeToken = themeManager.addObserver(self)
        return [dealToken, themeToken]
    }

    // MARK: - Navigation

    @objc private func didPressDeal(_ sender: UIBarButtonItem) {
        delegate?.showDeal()
    }

}

// MARK: - ViewStateRenderable
extension StoryViewController: ViewStateRenderable {
    typealias ResultType = Deal

    func render(_ viewState: ViewState<Deal>) {
        switch viewState {
        case .empty:
            break
        case .loading:
            break
        case .result(let deal):
            titleLabel.text = deal.story.title
            bodyText.markdownText = deal.story.body
        case .error(let error):
            log.error("\(#function): \(error.localizedDescription)")
        }
    }
}

// MARK: - Themeable
extension StoryViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        dealButton.tintColor = theme.accentColor

        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        bodyText.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor

        // foreground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.foreground.textColor]
        titleLabel.textColor = theme.foreground.textColor
        bodyText.textColor = theme.foreground.textColor
        navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        //setNeedsStatusBarAppearanceUpdate()
    }
}
