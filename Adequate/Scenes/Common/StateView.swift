//
//  StateView.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/12/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class StateView: UIView {

    var onRetry: (() -> Void)?
    var emptyMessageText: String = Strings.emptyMessage
    var loadingMessageText: String? = Strings.loadingMessage {
        didSet {
            activityMessageLabel.text = loadingMessageText
        }
    }

    // MARK: - Appearance

    var foreground: ThemeForeground {
        didSet {
            switch foreground {
            case .dark:
                activityIndicator.style = .gray
                activityMessageLabel.textColor = .black
                messageLabel.textColor = .gray
                retryButton.layer.borderColor = UIColor.gray.cgColor
                retryButton.setTitleColor(.gray, for: .normal)
            case .light:
                activityIndicator.style = .white
                activityMessageLabel.textColor = .white
                messageLabel.textColor = .gray
                retryButton.layer.borderColor = UIColor.gray.cgColor
                retryButton.setTitleColor(.gray, for: .normal)
            case .unknown(let rawValue):
                log.warning("\(#function) - rawValue: \(rawValue)")
            }
        }
    }

    // MARK: - Subviews

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var activityMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.text = loadingMessageText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// TODO: UIStackView?

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Strings.retryButton, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300.0, height: 100.0)
    }

    // MARK: - Lifecycle

    convenience init(foreground: ThemeForeground = .dark) {
        self.init(frame: CGRect.zero)
        self.foreground = foreground
    }

    override init(frame: CGRect) {
        self.foreground = .dark
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        self.foreground = .dark
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
        let guide = safeAreaLayoutGuide

        /// TODO: move these into class property?
        let spacing: CGFloat = 8.0
        //let sideMargin: CGFloat = 16.0
        let sideMargin: CGFloat = 0.0
        //let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: centerYAnchor),
            // activityMessageLabel
            activityMessageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: sideMargin),
            activityMessageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -sideMargin),
            activityMessageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 4.0),
            // messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: sideMargin),
            messageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -sideMargin),
            messageLabel.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: spacing * -2.0),
            // retryButton
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: centerYAnchor, constant: spacing),
        ])
    }

    // MARK: - Retry

    @objc func didPressRetry(_ sender: UIButton) {
        onRetry?()
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
            messageLabel.text = emptyMessageText
            retryButton.isHidden = true
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
            /// TODO: animate here or in caller?
            UIView.animate(withDuration: 0.3, animations: {
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
    func apply(theme: AppTheme) {
        // accentColor

        // backgroundColor
        //backgroundColor = theme.backgroundColor

        // foreground
        foreground = theme.foreground
    }
}

// MARK: - Strings
fileprivate enum Strings {
    // Buttons
    static let retryButton = "Retry"
    // Message Labels
    static let emptyMessage = "There was no data"
    static let loadingMessage = "LOADING"
}
