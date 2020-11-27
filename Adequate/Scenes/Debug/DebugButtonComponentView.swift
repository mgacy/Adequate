//
//  DebugButtonComponentView.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/13/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class DebugButtonComponentView: UIView {

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var info: String? {
        didSet {
            infoLabel.text = info
        }
    }

    var buttonTitle: String? {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    var buttonAction: (() -> Void)?

    // MARK: - Appearance

    var horizontalInset: CGFloat = 16.0

    // MARK: - Subviews

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = AppTheme.CornerRadius.extraSmall
        button.backgroundColor = button.tintColor
        button.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [button, activityIndicator, infoLabel])
        view.axis = .horizontal
        //view.alignment = .center
        view.alignment = .firstBaseline
        //view.distribution = .fillEqually
        view.distribution = .fill
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, horizontalStackView])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override public var intrinsicContentSize: CGSize {
        return verticalStackView.intrinsicContentSize
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(verticalStackView)
        setupConstraints()
    }

    private func setupConstraints() {
        let guide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalInset),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: horizontalInset / 2.0),
            verticalStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalInset),
            verticalStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -horizontalInset / 2.0)
        ])
    }

    // MARK: Actions

    @objc private func didPressButton(_ sender: UIButton) {
        buttonAction?()
    }

}
