//
//  HistoryListViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/13/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Combine

// MARK: - Delegate

protocol HistoryListViewControllerDelegate: AnyObject {
    typealias Deal = DealHistoryQuery.Data.DealHistory.Item
    func showHistoryDetail(with: Deal)
    func showSettings()
    func showDeal()
}

// MARK: - View Controller

final class HistoryListViewController: UITableViewController {
    typealias Dependencies = HasDataProvider & HasThemeManager
    typealias Deal = DealHistoryQuery.Data.DealHistory.Item

    weak var delegate: HistoryListViewControllerDelegate?

    private let themeManager: ThemeManagerType
    private let dataProvider: DataProviderType
    private lazy var dataSource = makeDataSource(for: tableView)
    private var cancellables: Set<AnyCancellable> = []
    private var initialSetupDone = false
    private var wasRefreshedManually = false

    private var viewState: ViewState<[Deal]> {
        dataProvider.historyState
    }

    // MARK: - Subviews

    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "SettingsNavBar"), style: .plain, target: self, action: #selector(didPressSettings(_:)))
        button.accessibilityLabel = L10n.Accessibility.settingsButton
        return button
    }()

    private lazy var dealButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "RightChevronNavBar"), style: .plain, target: self, action: #selector(didPressDeal(_:)))
        button.accessibilityLabel = L10n.Accessibility.rightChevronButton
        return button
    }()

    private lazy var tableHeaderView: UIView = {
        return UIView()
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.themeManager = dependencies.themeManager
        self.dataProvider = dependencies.dataProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //override func viewWillAppear(_ animated: Bool) {
    //    super.viewWillAppear(animated)
    //    if case .empty = viewState {
    //        getDealHistory()
    //    }
    //}

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        // Ensure we wait until tableView is in the view hierarchy before potentially telling it to layout its visible
        // cells
        if !initialSetupDone {
            dataProvider.historyPublisher
                .sink { [weak self] viewState in
                    self?.render(viewState)
                }
                .store(in: &cancellables)
        }
        if case .empty = viewState {
            getDealHistory()
        }
    }

    // MARK: - View Methods

    private func setupView() {
        title = L10n.history
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = dealButton

        //navigationController?.navigationBar.barTintColor = ColorCompatibility.systemBackground
        //navigationController?.navigationBar.tintColor = ColorCompatibility.label
        //navigationController?.navigationBar.prefersLargeTitles = true

        // Try to fix UIRefreshControl issues
        edgesForExtendedLayout = [.all] // [.top]?
        extendedLayoutIncludesOpaqueBars = true

        //view.backgroundColor = ColorCompatibility.systemBackground
        //tableView.backgroundColor = ColorCompatibility.systemBackground

        setupTableView()

        themeManager.themePublisher
            .sink { [weak self] theme in
                self?.apply(theme: theme)
            }
            .store(in: &cancellables)
    }

    private func setupTableView() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlDidChange(_:)), for: .valueChanged)
        tableView.tableFooterView = UIView() // Prevent empty rows

        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 88.0
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        //tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(cellType: HistoryListCell.self)
    }

    // MARK: - DataProvider

    private func getDealHistory() {
        dataProvider.getDealHistory()
    }

    // MARK: - Navigation

    @objc private func didPressSettings(_ sender: UIBarButtonItem) {
        delegate?.showSettings()
    }

    @objc private func didPressDeal(_ sender: UIBarButtonItem) {
        delegate?.showDeal()
    }

    @objc func refreshControlDidChange(_ sender: UIRefreshControl) {
        wasRefreshedManually = true
        getDealHistory()
    }
}

// MARK: - TableViewDataSourceConfigurable
extension HistoryListViewController: TableViewDiffableDataSourceProvider {
    typealias CellType = HistoryListCell
    typealias SectionType = SingleSection
    typealias ItemType = Deal
}

// MARK: - UITableViewDelegate
extension HistoryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         guard let deal = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        delegate?.showHistoryDetail(with: deal)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
}

// MARK: - ViewStateRenderable
extension HistoryListViewController: ViewStateRenderable {

    func render(_ viewState: ViewState<[Deal]>) {
        switch viewState {
        case .empty:
            if let refreshControl = refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            // Add `lazy var backgroundView: TableBackgroundView` in order to handle AppTheme?
            tableView.setBackgroundView(title: nil, message: L10n.emptyHistoryMessage)
            dataSource.apply(SingleSection.makeSnapshot(for: []))
        case .loading:
            if wasRefreshedManually {
                wasRefreshedManually = false
            } else if let refreshControl = refreshControl {
                tableView.setContentOffset(
                    CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.size.height), animated: true)
                refreshControl.beginRefreshing()
            }
            tableView.restore()
        case .result(let deals):
            if let refreshControl = refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            } else {
                // Handle transition from .error / .empty -> .result
                tableView.restore(animated: false)
            }
            dataSource.apply(SingleSection.makeSnapshot(for: deals))
        case .error(let error):
            if let refreshControl = refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            if tableView.visibleCells.isEmpty {
                tableView.setBackgroundView(error: error)
            } else {
                // TODO: show less obtrusive error view?
                self.displayError(error: error, completion: nil)
            }
        }
        initialSetupDone = true
    }
}

// MARK: - ThemeObserving
extension HistoryListViewController: ThemeObserving {
    func apply(theme: AppTheme) {
        apply(theme: theme.baseTheme)
    }
}

// MARK: - Themeable
extension HistoryListViewController: Themeable {
    func apply(theme: ColorTheme) {
        // accentColor
        navigationController?.navigationBar.tintColor = theme.tint

        // backgroundColor
        navigationController?.navigationBar.barTintColor = theme.systemBackground
        //navigationController?.navigationBar.layoutIfNeeded() // Animate color change
        view.backgroundColor = theme.systemBackground
        tableView.backgroundColor = theme.systemBackground

        refreshControl?.tintColor = theme.secondaryLabel
    }
}
