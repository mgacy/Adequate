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

    private let contentView: StoryContentView = {
        let view = StoryContentView()
        view.preservesSuperviewLayoutMargins = true
        view.backgroundColor = ColorCompatibility.systemBackground
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
        scrollView.addSubview(contentView)
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
        navigationController?.applyStyle(.hiddenSeparator)
        title = L10n.story
        observationTokens = setupObservations()
    }

    private func setupConstraints() {
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            // scrollView
            frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameGuide.topAnchor.constraint(equalTo: view.topAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // stackView
            contentGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentGuide.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
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
            contentView.title = deal.story.title
            contentView.body = deal.story.body
        case .error(let error):
            log.error("\(#function): \(error.localizedDescription)")
        }
    }
}

// MARK: - ThemeObserving
extension StoryViewController: ThemeObserving {
    func apply(theme: AppTheme) {
        apply(theme: theme.dealTheme ?? theme.baseTheme)
        if let foreground = theme.foreground {
            apply(foreground: foreground)
        }
    }
}

// MARK: - Themeable
extension StoryViewController: Themeable {
    func apply(theme: ColorTheme) {
        // accentColor
        dealButton.tintColor = theme.tint

        // backgroundColor
        view.backgroundColor = theme.systemBackground
        //navigationController?.navigationBar.barTintColor = theme.label
        navigationController?.navigationBar.barTintColor = theme.systemBackground
        //navigationController?.navigationBar.layoutIfNeeded() // Animate color change

        // foreground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.label]
        //navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        //setNeedsStatusBarAppearanceUpdate()

        // Subviews
        contentView.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
extension StoryViewController: ForegroundThemeable {}
