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

final class StoryViewController: BaseViewController<ScrollableView<StoryContentView>> {
    typealias Dependencies = HasDataProvider & HasThemeManager

    weak var delegate: StoryViewControllerDelegate?

    private let dataProvider: DataProviderType
    private let themeManager: ThemeManagerType

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

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.viewState = .empty
        self.dataProvider = dependencies.dataProvider
        self.themeManager = dependencies.themeManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Methods

    override func setupView() {
        navigationItem.leftBarButtonItem = dealButton
        navigationController?.applyStyle(.hiddenSeparator)
        title = L10n.story
    }

    override func setupObservations() -> [ObservationToken] {
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
            rootView.contentView.title = deal.story.title
            rootView.contentView.body = deal.story.body
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
        navigationController?.navigationBar.tintColor = theme.tint

        // backgroundColor
        //navigationController?.navigationBar.barTintColor = theme.label
        navigationController?.navigationBar.barTintColor = theme.systemBackground
        //navigationController?.navigationBar.layoutIfNeeded() // Animate color change

        // foreground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.label]
        //navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        //setNeedsStatusBarAppearanceUpdate()

        // Subviews
        rootView.apply(theme: theme)
    }
}

// MARK: - ForegroundThemeable
extension StoryViewController: ForegroundThemeable {}
