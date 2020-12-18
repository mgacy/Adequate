//
//  StateView.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/12/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

// TODO: make this a view controller
final class StateView: UIView {

    var onRetry: (() -> Void)?

    var emptyMessageText: String = L10n.emptyMessage

    var loadingMessageText: String? = L10n.loadingMessage {
        didSet {
            activityMessageLabel.text = loadingMessageText
        }
    }

    // MARK: - Subviews

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var activityMessageLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.centered <> StyleBook.Label.secondary)
        label.text = L10n.loadingMessage
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base <> StyleBook.Label.centered)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(style: StyleBook.Button.secondaryWide)
        button.setTitle(L10n.retry, for: .normal)
        return button
    }()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300.0, height: 100.0)
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
        addSubview(activityIndicator)
        addSubview(activityMessageLabel)
        addSubview(messageLabel)
        addSubview(retryButton)
        retryButton.addTarget(self, action: #selector(didPressRetry(_:)), for: .touchUpInside)
        setupConstraints()
    }

    private func setupConstraints() {
        let readableGuide = readableContentGuide
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: centerYAnchor),
            // activityMessageLabel
            activityMessageLabel.leadingAnchor.constraint(equalTo: readableGuide.leadingAnchor),
            activityMessageLabel.trailingAnchor.constraint(equalTo: readableGuide.trailingAnchor),
            activityMessageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 4.0),
            // messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: readableGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: readableGuide.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: AppTheme.spacing * -2.0),
            messageLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            // retryButton
            // TODO: allow messageLabel to push retryButton down?
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: centerYAnchor, constant: AppTheme.spacing)
        ])
    }

    // MARK: - Retry

    @objc func didPressRetry(_ sender: UIButton) {
        onRetry?()
    }

}

// MARK: - UITraitEnvironment
extension StateView {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // We need to handle `CALayer` manually
            let resovedColor = UIColor.secondaryLabel.resolvedColor(with: traitCollection)
            retryButton.layer.borderColor = resovedColor.cgColor
        }
    }
}

extension StateView {
    func render<T>(_ viewState: ViewState<T>) {
        switch viewState {
        case .empty:
            isHidden = false
            activityIndicator.stopAnimating()
            activityMessageLabel.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = L10n.emptyMessage
            retryButton.isHidden = true // ?
        case .error(let error):
            isHidden = false
            activityIndicator.stopAnimating()
            activityMessageLabel.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = error.localizedDescription
            retryButton.isHidden = false
        case .loading:
            isHidden = false
            activityIndicator.startAnimating()
            activityMessageLabel.isHidden = false
            messageLabel.isHidden = true
            retryButton.isHidden = true
        case .result:
            activityIndicator.stopAnimating()
            isHidden = true
            /*
            // TODO: animate here or in caller?
            UIView.animate(withDuration: 0.3, animations: {
                // FIXME: can't animate `isHidden`
                // see: https://stackoverflow.com/a/29080894
                self.isHidden = true
                self.activityIndicator.stopAnimating()
                self.activityMessageLabel.isHidden = true
                self.messageLabel.isHidden = true
                self.retryButton.isHidden = true
            })
            */
        }
    }
}

// MARK: - Themeable
extension StateView: Themeable {
    func apply(theme: ColorTheme) {
        // backgroundColor
        //backgroundColor = theme.systemBackground

        // foreground
        activityIndicator.color = theme.secondaryLabel
        activityMessageLabel.textColor = theme.secondaryLabel
        messageLabel.textColor = theme.secondaryLabel
        retryButton.layer.borderColor = theme.secondaryLabel.cgColor
        retryButton.setTitleColor(theme.secondaryLabel, for: .normal)
    }
}
