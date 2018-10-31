//
//  WelcomeViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/25/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    private enum Strings {
        static let title = "Welcome to Adequate"
        static let body = "The most adequate app to see what crap meh is trying to sell you."
    }

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = Strings.title
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = Strings.body
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 5.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override func loadView() {
        let view = UIView()
        view.addSubview(stackView)
        self.view = view
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
        view.backgroundColor = .white
        // ...
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
        ])
    }

    // MARK: - A

    // ...

}
