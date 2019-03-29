//
//  HistoryListCell.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class HistoryListCell: UITableViewCell {

    private var observationToken: ObservationToken?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()
        //selectedBackgroundView?.backgroundColor = .gray
        textLabel?.numberOfLines = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        observationToken?.cancel()
    }

    deinit {
        observationToken?.cancel()
    }

    // MARK: - Selection / Highlight

    //override func setSelected(_ selected: Bool, animated: Bool) {}

    //override func setHighlighted(_ highlighted: Bool, animated: Bool) {}

}

// MARK: - Configuration
extension HistoryListCell {
    typealias Deal = ListDealsForPeriodQuery.Data.ListDealsForPeriod

    func configure(with deal: Deal) {
        textLabel?.text = deal.title

        if let createdAt = DateFormatter.iso8601Full.date(from: deal.createdAt) {
            detailTextLabel?.text = DateFormatter.yyyyMMdd.string(from: createdAt)
        } else {
            detailTextLabel?.text = deal.createdAt
        }
    }

    func setupThemeObservation(_ themeManager: ThemeManagerType) {
        observationToken = themeManager.addObserver(self)
    }
}

// MARK: - Themeable
extension HistoryListCell: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        selectedBackgroundView?.backgroundColor = theme.accentColor
        // backgroundColor
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        // foreground
        textLabel?.textColor = theme.foreground.textColor
        detailTextLabel?.textColor = theme.foreground.textColor
    }
}
