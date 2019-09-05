//
//  DebugViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {
    typealias Dependencies = AppDependency

    let dependencies: Dependencies
    weak var dismissalDelegate: VoidDismissalDelegate?

    private var observationTokens: [ObservationToken] = []

    // MARK: - Subviews

    private lazy var button1: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "HistoryNavBar"), style: .plain, target: self, action: #selector(didPressButton1(_:)))
        return button
    }()

    private lazy var button2: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "HistoryNavBar"), style: .plain, target: self, action: #selector(didPressButton2(_:)))
        return button
    }()

    private lazy var button3: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "HistoryNavBar"), style: .plain, target: self, action: #selector(didPressButton3(_:)))
        return button
    }()

    private lazy var button4: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "HistoryNavBar"), style: .plain, target: self, action: #selector(didPressButton4(_:)))
        return button
    }()

    // TODO: add scrollView and contentView?

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()

        // ...

        navigationItem.leftBarButtonItems = [button1, button2]
        navigationItem.rightBarButtonItems = [button4, button3]
        self.view = view
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observationTokens = setupObservations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    func setupView() {
        view.backgroundColor = .white
        title = "Debug"
        // ...
    }

    func setupConstraints() {
        //let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //view.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0.0),
            //view.topAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0.0),
            //view.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0.0),
            //view.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: 0.0)
        ])
    }

    private func setupObservations() -> [ObservationToken] {
        return []
    }

    // MARK: - Actions

    @objc private func didPressButton1(_ sender: UIBarButtonItem) {
        print("\(#function)")
        // ...
    }

    @objc private func didPressButton2(_ sender: UIBarButtonItem) {
        print("\(#function)")
        // ...
    }

    @objc private func didPressButton3(_ sender: UIBarButtonItem) {
        print("\(#function)")
        // ...
    }

    @objc private func didPressButton4(_ sender: UIBarButtonItem) {
        print("\(#function)")
        // ...
    }

}

// MARK: - VoidDismissalDelegate
extension DebugViewController: VoidDismissalDelegate {

    func dismiss() {
        dismissalDelegate?.dismiss()
    }
}
