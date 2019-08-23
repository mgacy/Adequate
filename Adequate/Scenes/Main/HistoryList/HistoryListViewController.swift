//
//  HistoryListViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/13/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Delegate

protocol HistoryListViewControllerDelegate: class {
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod
    func showHistoryDetail(with: Deal)
    func showSettings()
    func showDeal()
}

// MARK: - View Controller

final class HistoryListViewController: UIViewController {
    typealias Dependencies = HasDataProvider
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    weak var delegate: HistoryListViewControllerDelegate?

    //private let themeManager: ThemeManagerType
    private let dataSource: HistoryListDataSource
    private var observationTokens: [ObservationToken] = []

    // MARK: - Subviews

    private lazy var settingsButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "SettingsNavBar"), style: .plain, target: self, action: #selector(didPressSettings(_:)))
    }()

    private lazy var dealButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "RightChevronNavBar"), style: .plain, target: self, action: #selector(didPressDeal(_:)))
    }()

    private lazy var stateView: StateView = {
        let view = StateView()
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDealHistory()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlDidChange(_:)), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.tableFooterView = UIView() // Prevent empty rows
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private lazy var tableHeaderView: UIView = {
        return UIView()
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        //self.themeManager = dependencies.themeManager
        self.dataSource = HistoryListDataSource(dependencies: dependencies)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        //let view = UIView()
        view.addSubview(stateView)
        view.addSubview(tableView)
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = dealButton
        //self.view = view
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getDealHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        title = L10n.history
        navigationController?.navigationBar.barTintColor = .white
        settingsButton.tintColor = .black
        dealButton.tintColor = .black
        stateView.foreground = .dark
        view.backgroundColor = .white
        tableView.backgroundColor = .white

        setupTableView()
        observationTokens = setupObservations()
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // stateView
            stateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: AppTheme.sideMargin),
            stateView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -AppTheme.sideMargin),
            // tableView
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 88.0
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.register(cellType: HistoryListCell.self)
    }

    private func setupObservations() -> [ObservationToken] {
        let historyToken = dataSource.addObserver(self) { vc, state in
            vc.render(state)
        }
        return [historyToken]
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
        getDealHistory()
    }

}

// MARK: - UITableViewDelegate
extension HistoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deal = dataSource.objectAtIndexPath(indexPath)
        delegate?.showHistoryDetail(with: deal)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
}

// MARK: - ViewStateRenderable
extension HistoryListViewController: ViewStateRenderable {
    typealias ResultType = TableViewDiff

    func render(_ viewState: ViewState<ResultType>) {
        stateView.render(viewState)
        switch viewState {
        case .empty:
            stateView.isHidden = false
            tableView.isHidden = true
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        case .loading:
            stateView.isHidden = false
            tableView.isHidden = true
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.size.height),
                                       animated: true)
            refreshControl.beginRefreshing()
        case .result(let diff):
            stateView.isHidden = true
            tableView.isHidden = false

            if #available(iOS 9999, *) { // Swift 5.1 returns true
                log.debug("\(#function) - \(diff)")
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: diff.deletedIndexPaths, with: .fade)
                    tableView.insertRows(at: diff.insertedIndexPaths, with: .right)
                }, completion: { completed in
                    log.debug("All done updating!")
                    self.refreshControl.endRefreshing()
                })
            } else {
                log.debug("Performing simple data reload")
                tableView.reloadData()
                refreshControl.endRefreshing()
            }
        case .error:
            stateView.isHidden = false
            tableView.isHidden = true
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
}
