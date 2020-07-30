//
//  HistoryListViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/13/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Delegate

protocol HistoryListViewControllerDelegate: AnyObject {
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod
    func showHistoryDetail(with: Deal)
    func showSettings()
    func showDeal()
}

// MARK: - View Controller

final class HistoryListViewController: UITableViewController {
    typealias Dependencies = HasDataProvider & HasThemeManager
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    weak var delegate: HistoryListViewControllerDelegate?

    private let themeManager: ThemeManagerType
    private let dataSource: HistoryListDataSource
    private var observationTokens: [ObservationToken] = []
    private var initialSetupDone = false
    private var wasRefreshedManually = false

    // MARK: - Subviews

    private lazy var settingsButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "SettingsNavBar"), style: .plain, target: self, action: #selector(didPressSettings(_:)))
    }()

    private lazy var dealButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "RightChevronNavBar"), style: .plain, target: self, action: #selector(didPressDeal(_:)))
    }()

    private lazy var tableHeaderView: UIView = {
        return UIView()
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.themeManager = dependencies.themeManager
        self.dataSource = HistoryListDataSource(dependencies: dependencies)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // TODO: refresh on viewDidLoad() or on viewWillAppear(_:)?
        if case .empty = dataSource.state {
            getDealHistory()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit { observationTokens.forEach { $0.cancel() } }

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
        observationTokens = setupObservations()
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

    private func setupObservations() -> [ObservationToken] {
        let historyToken = dataSource.addObserver(self) { vc, state in
            vc.render(state)
        }
        let themeToken = themeManager.addObserver(self)
        return [historyToken, themeToken]
    }

    // MARK: - DataProvider

    private func getDealHistory() {
        // TODO: account for TimeZones
        let today = Date()
        // TODO: move startDate / endDate to class properties?
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        dataSource.getDealHistory(from: startDate, to: endDate)
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

// MARK: - UITableViewDelegate
extension HistoryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deal = dataSource.objectAtIndexPath(indexPath)
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
    typealias ResultType = TableViewDiff

    func render(_ viewState: ViewState<ResultType>) {
        switch viewState {
        case .empty:
            if let refreshControl = refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            // Add `lazy var backgroundView: TableBackgroundView` in order to handle AppTheme?
            tableView.setBackgroundView(title: nil, message: "There are no deals")
        case .loading:
            if wasRefreshedManually {
                wasRefreshedManually = false
            } else if let refreshControl = refreshControl {
                tableView.setContentOffset(
                    CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.size.height), animated: true)
                refreshControl.beginRefreshing()
            }
            tableView.restore()
        case .result(let diff):
            if let refreshControl = refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            } else {
                // Handle transition from .error / .empty -> .result
                tableView.restore(animated: false)
            }

            // There is no need to perform updates when `render(_:)` is called on `addObserver(_:closure:)`
            if !initialSetupDone {
                initialSetupDone = true
                return
            }

            // FIXME: handle situation where there is no diff
            // Should diff be optional, or should we just skip batch updates if both `.deletedIndexPaths` and `.insertedIndexPaths` are empty?

            // TODO: ensure tableView.backgroundView == nil? Assumption is that .loading always precedes .result
            tableView.performBatchUpdates({
                tableView.deleteRows(at: diff.deletedIndexPaths, with: .fade)
                tableView.insertRows(at: diff.insertedIndexPaths, with: .automatic)
            })
        case .error(let error):
            if let refreshControl = refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            if dataSource.isEmpty {
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

        // foreground
        // TODO: set home indicator color?
        //navigationController?.navigationBar.barStyle = theme.foreground.navigationBarStyle
        //setNeedsStatusBarAppearanceUpdate()
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
