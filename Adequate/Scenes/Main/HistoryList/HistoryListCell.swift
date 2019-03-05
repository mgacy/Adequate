//
//  HistoryListCell.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

final class HistoryListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Configuration
extension HistoryListCell {
    func configure(with deal: Deal) {
        textLabel?.text = deal.title

        let createdAt = Date()
        detailTextLabel?.text = DateFormatter.yyyyMMdd.string(from: createdAt)
    }
}
