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
    func showHistoryDetail()
    func showSettings()
    func showDeal()
}

// MARK: - View Controller

final class HistoryListViewController: UIViewController {
    typealias Dependencies = HasThemeManager

    weak var delegate: HistoryListViewControllerDelegate?

    private let themeManager: ThemeManagerType

    // MARK: - Subviews

    private lazy var settingsButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(didPressSettings(_:)))
    }()

    private lazy var dealButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .fastForward, target: self,
                               action: #selector(didPressDeal(_:)))
    }()

    private lazy var showButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didPressDetail), for: .touchUpInside)
        button.setTitle("Detail", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.themeManager = dependencies.themeManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        //let view = UIView()
        view.addSubview(showButton)
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = dealButton
        //self.view = view
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    func setupView() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white

        if let theme = themeManager.theme {
            apply(theme: theme)
        }
    }

    func setupConstraints() {
        /*
        let guide = view.safeAreaLayoutGuide
        let sideMargin: CGFloat = 16.0
        */
        NSLayoutConstraint.activate([
            showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Navigation

    @objc private func didPressDetail() {
        delegate?.showHistoryDetail()
    }

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

        // foreground
        // ...
    }
}
