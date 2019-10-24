//
//  HistoryListCell.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class HistoryListCell: UITableViewCell {

    //var deal: Deal?
    var theme: Theme?

    // MARK: - Subivews

    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

     private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
     }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 2.0 // FIXME: use constant
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        theme = nil
        //titleLabel.text = nil
        //dateLabel.text = nil
    }

    // MARK: - View Configuration
    /*
    func setupView() {
        selectedBackgroundView = UIView()
        contentView.addSubview(cardView)
        cardView.addSubview(stackView)
    }

    func setupConstraints() {
        let guide = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // cardView
            cardView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: AppTheme.sideMargin),
            cardView.topAnchor.constraint(equalTo: guide.topAnchor, constant: AppTheme.spacing / 2.0),
            cardView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -AppTheme.sideMargin),
            cardView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -AppTheme.spacing / 2.0),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppTheme.spacing),
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: AppTheme.spacing),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppTheme.spacing),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -AppTheme.spacing)
        ])
    }
    */
    // NEW
    func setupView() {
        selectedBackgroundView = UIView()
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(dateLabel)
    }

    func setupConstraints() {
        let guide = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // cardView
            cardView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: AppTheme.sideMargin),
            cardView.topAnchor.constraint(equalTo: guide.topAnchor, constant: AppTheme.spacing / 2.0),
            cardView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -AppTheme.sideMargin),
            cardView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -AppTheme.spacing / 2.0),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80.0),
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppTheme.spacing),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: AppTheme.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppTheme.spacing),
            // dateLabel
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: AppTheme.spacing),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppTheme.spacing),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -AppTheme.spacing),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppTheme.spacing)
        ])
    }

    // MARK: Animation

    private let brightnessDelta: CGFloat = 0.25
    private let animationDuration: TimeInterval = 0.2

    public func animateSelection() {
        guard let theme = theme else {
            return
        }
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: animationDuration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                switch theme.foreground {
                case .dark:
                    self.cardView.backgroundColor = theme.backgroundColor.adjust(brightnessBy: -self.brightnessDelta)
                case .light:
                    self.cardView.backgroundColor = theme.backgroundColor.adjust(brightnessBy: self.brightnessDelta)
                default:
                    break
                }
            }
        )
    }

    public func animateDeselection() {
        guard let theme = theme else {
            return
        }
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: animationDuration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.cardView.backgroundColor = theme.backgroundColor
            }
        )
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted && !isHighlighted {
            animateSelection()
        } else if !highlighted && isHighlighted {
            animateDeselection()
        }
        super.setHighlighted(highlighted, animated: animated)
    }

}

// MARK: - Configuration
extension HistoryListCell {
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    func configure(with deal: Deal) {
        apply(theme: Theme(deal.theme))
        titleLabel.text = deal.title
        if let createdAt = DateFormatter.iso8601Full.date(from: deal.createdAt) {
            dateLabel.text = DateFormatter.veryShortEST.string(from: createdAt)
        } else {
            dateLabel.text = deal.createdAt
        }
    }
}

// MARK: - Themeable
extension HistoryListCell {

    func apply(theme: Theme) {
        self.theme = theme
        // accentColor
        // backgroundColor
        cardView.backgroundColor = theme.backgroundColor
        // foreground
        titleLabel.textColor = theme.foreground.textColor
        dateLabel.textColor = theme.foreground.textColor.withAlphaComponent(0.6)
    }
}
/*
// MARK: - Config
extension HistoryListCell {
    fileprivate enum ViewConfig {
        // X
        static let cardCornerRadius: CGFloat = 5.0
        // Spacing
        static let spacing: CGFloat = 8.0
        static let sideMargin: CGFloat = 12.0
        static let labelSpacing: CGFloat = 2.0
        // Color
        static let dateLabelAlpha: CGFloat = 0.8
    }
}
*/
