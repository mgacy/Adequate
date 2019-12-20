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

    // ScrollView

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInsetAdjustmentBehavior = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorCompatibility.systemBackground
        return view
    }()

    var contentView: UIView

    // MARK: - Lifecycle

    init(dependencies: Dependencies, contentView: UIView) {
        self.contentView = contentView
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    init(dependencies: Dependencies) {
        self.contentView = UIView()
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
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
        navigationItem.leftBarButtonItems = [button1, button2]
        navigationItem.rightBarButtonItems = [button4, button3]
        view.backgroundColor = ColorCompatibility.systemBackground
        title = "Debug"
        // ...
    }

    private func setupConstraints() {
        //let guide = view.safeAreaLayoutGuide
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // contentView
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func setupObservations() -> [ObservationToken] {
        return []
    }

    // MARK: - Configuration

    public func addContentView(_ newContentView: UIView) {
        contentView.removeFromSuperview()

        contentView = newContentView
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(newContentView)
        NSLayoutConstraint.activate([
            newContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            newContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            newContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            newContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            newContentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
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
