//
//  TableBackgroundView.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class TableBackgroundView: UIView {

    // MARK: - Properties

    public var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = newValue == nil
        }
    }

    // TODO: add `retryButton` and `var onRetry: (() -> Void)?`?

    public var titleColor: UIColor {
        get {
            return titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
        }
    }

    public var message: String? {
        get {
            return messageLabel.text
        }
        set {
            messageLabel.text = newValue
        }
    }

    public var messageColor: UIColor {
        get {
            return messageLabel.textColor
        }
        set {
            messageLabel.textColor = newValue
        }
    }

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base <> StyleBook.Label.centered)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = ColorCompatibility.secondaryLabel
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel(style: StyleBook.Label.base <> StyleBook.Label.centered)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorCompatibility.secondaryLabel
        return label
    }()

    // MARK: - Lifecycle

    convenience init(title: String?, message: String?) {
        self.init(frame: CGRect.zero)
        self.title = title
        self.message = message
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    public override func didMoveToSuperview() {
        guard let safeTopAnchor = self.superview?.safeAreaLayoutGuide.topAnchor else { return }
        titleLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: safeTopAnchor,
                                        multiplier: 1.0).isActive = true
    }

    //deinit { print("\(#function) - \(self.description)") }

    // MARK: - Configuration

    private func configure() {
        addSubview(titleLabel)
        addSubview(messageLabel)

        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            // messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            messageLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0),
            messageLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

// MARK: - UITableView + TableBackgroundView
extension UITableView {

    /// Add `TableBackgroundView` as background view.
    /// - Parameters:
    ///   - title: The title to display in background view.
    ///   - message: The message to display in background view.
    func setBackgroundView(title: String?, message: String?) {
        let emptyView = TableBackgroundView(title: title, message: message)
        emptyView.preservesSuperviewLayoutMargins = true
        backgroundView = emptyView
    }

    /// Add `TableBackgroundView` view containing error message as background view.
    /// - Parameter error: The error message to display.
    func setBackgroundView(error: Error) {
        setBackgroundView(title: L10n.error, message: error.localizedDescription)
    }

    /// Remove background view.
    /// - Parameter animated: Animate `backgroundView.alpha` to 0 before removing.
    func restore(animated: Bool = true) {
        if animated {
            guard let backgroundView = backgroundView else {
                return
            }
            UIView.animate(withDuration: 0.3,
                           animations: { backgroundView.alpha = 0.0 },
                           completion: { [weak self] _ in
                                guard self?.backgroundView === backgroundView else {
                                    // backgroundView has already been replaced by another
                                    return
                                }
                                self?.backgroundView = nil
                            })
        } else {
            backgroundView = nil
        }
    }
}

// MARK: - Themeable
extension TableBackgroundView: Themeable {
    func apply(theme: ColorTheme) {
        backgroundColor = theme.systemBackground
        titleLabel.textColor = theme.label
        messageLabel.textColor = theme.secondaryLabel
    }
}
