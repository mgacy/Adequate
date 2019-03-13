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
    typealias Dependencies = HasDataProvider & HasThemeManager
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    weak var delegate: HistoryListViewControllerDelegate?

    private let themeManager: ThemeManagerType
    private let dataSource: HistoryListDataSource
    private var observationTokens: [ObservationToken] = []

    // MARK: - Subviews

    private lazy var settingsButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "SettingsNavBar"), style: .plain, target: self, action: #selector(didPressSettings(_:)))
    }()

    private lazy var dealButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "RightChevronNavBar"), style: .plain, target: self, action: #selector(didPressDeal(_:)))
    }()

    private lazy var stateView: StateView<Void> = {
        let view = StateView<Void>()
        view.onRetry = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getDealHistory()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.tableFooterView = UIView() // Prevent empty rows
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
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
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
        apply(theme: themeManager.theme)
        setupTableView()
        observationTokens = setupObservations()
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // stateView
            stateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateView.heightAnchor.constraint(equalToConstant: 100.0),
            // tableView
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
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
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        dataSource.getDealHistory(from: startDate, to: Date())
    }

    // MARK: - Navigation

    @objc private func didPressSettings(_ sender: UIBarButtonItem) {
        delegate?.showSettings()
    }

    @objc private func didPressDeal(_ sender: UIBarButtonItem) {
        delegate?.showDeal()
    }

}

// MARK: - Themeable
extension HistoryListViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        // ...

        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor

        // foreground
        // ...

        stateView.apply(theme: theme)
    }
}

// MARK: - UITableViewDelegate
extension HistoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deal = dataSource.objectAtIndexPath(indexPath)
        delegate?.showHistoryDetail(with: deal)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ViewStateRenderable
extension HistoryListViewController: ViewStateRenderable {
    typealias ResultType = Void

    func render(_ viewState: ViewState<Void>) {
        stateView.render(viewState)
        switch viewState {
        case .empty:
            stateView.isHidden = false
            tableView.isHidden = true
        case .loading:
            stateView.isHidden = false
            tableView.isHidden = true
        case .result:
            stateView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        case .error:
            stateView.isHidden = false
            tableView.isHidden = true
        }
    }
}
