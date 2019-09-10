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

    // Navigation bar actions
    var button1Action: (() -> Void)?
    var button2Action: (() -> Void)?
    var button3Action: (() -> Void)?
    var button4Action: (() -> Void)?

    // MARK: - Subviews

    // Navigation Bar

    private lazy var button1: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "1", style: .plain, target: self, action: #selector(didPressButton1(_:)))
        return button
    }()

    private lazy var button2: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "2", style: .plain, target: self, action: #selector(didPressButton2(_:)))
        return button
    }()

    private lazy var button3: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "3", style: .plain, target: self, action: #selector(didPressButton3(_:)))
        return button
    }()

    private lazy var button4: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "4", style: .plain, target: self, action: #selector(didPressButton4(_:)))
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

        // Navigation bar
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

    private func setupView() {
        view.backgroundColor = .white
        title = "Debug"
        // ...
    }

    private func setupConstraints() {
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

    // MARK: - Actions - Nav Bar

    @objc private func didPressButton1(_ sender: UIBarButtonItem) {
        button1Action?()
    }

    @objc private func didPressButton2(_ sender: UIBarButtonItem) {
        button2Action?()
    }

    @objc private func didPressButton3(_ sender: UIBarButtonItem) {
        button3Action?()
    }

    @objc private func didPressButton4(_ sender: UIBarButtonItem) {
        button4Action?()
    }

    // MARK: - Actions

    @objc private func didPressDismiss(_ sender: UIButton) {
        dismissalDelegate?.dismiss()
    }

}

// MARK: - VoidDismissalDelegate
extension DebugViewController: VoidDismissalDelegate {

    func dismiss() {
        dismissalDelegate?.dismiss()
    }
}
