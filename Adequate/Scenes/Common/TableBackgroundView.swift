//
//  TableBackgroundView.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class TableBackgroundView: UIView {

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

    // TODO: replace `titleColor` and `messageColor` with `foreground: ThemeForeground`? See `StateView`
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
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = ColorCompatibility.label
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorCompatibility.secondaryLabel
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        view.axis = .vertical
        view.spacing = AppTheme.spacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    //deinit { print("\(#function) - \(self.description)") }

    // MARK: - Configuration

    private func configure() {
        addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -AppTheme.widthInset)
        ])
    }

}

// MARK: - UITableView + TableBackgroundView

extension UITableView {

    func setBackgroundView(title: String?, message: String?) {
        let emptyView = TableBackgroundView(title: title, message: message)
        backgroundView = emptyView

        guard let parent = superview else {
            emptyView.frame = CGRect(x: self.center.x, y: self.center.y,
                                     width: self.bounds.size.width,
                                     height: self.bounds.size.height)
            return
        }
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            emptyView.topAnchor.constraint(equalTo: parent.topAnchor),
            emptyView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])
    }

    func setBackgroundView(error: Error) {
        setBackgroundView(title: L10n.error, message: error.localizedDescription)
    }

    func restore(animated: Bool = true) {
        if animated {
            guard let backgroundView = backgroundView else {
                return
            }
            UIView.animate(withDuration: 0.3,
                           animations: { backgroundView.alpha = 0.0 },
                           completion: { _ in
                                // TODO: only set to nil if completed?
                                guard self.backgroundView === backgroundView else {
                                    // backgroundView has already been replaced by another
                                    return
                                }
                                self.backgroundView = nil
                            })
        } else {
            backgroundView = nil
        }
    }
}

// MARK: - Themeable
extension TableBackgroundView: Themeable {
    func apply(theme: AppTheme) {
        // accentColor

        // backgroundColor
        backgroundColor = theme.backgroundColor

        // foreground
        //foreground = theme.foreground
        titleLabel.textColor = theme.foreground.textColor
        // TODO: how to color messageLabel?
    }
}
