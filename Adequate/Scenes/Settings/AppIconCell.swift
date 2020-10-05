//
//  AppIconCell.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/4/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

final class AppIconCell: UITableViewCell {

    private(set) var icon: AppIconViewController.AppIcon?

    init(style: CellStyle = .default) {
        super.init(style: style, reuseIdentifier: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView, let textLabel = textLabel else {
            return
        }

        let inset: CGFloat = 8.0
        imageView.frame = imageView.frame.inset(
            by: UIEdgeInsets(top: inset, left: 0.0, bottom: inset, right: inset * 2.0))
        textLabel.frame = textLabel.frame.inset(
            by: UIEdgeInsets(top: 0.0, left: inset * -2.0, bottom: 0.0, right: 0.0))
        separatorInset = UIEdgeInsets(top: 0.0, left: textLabel.frame.minX, bottom: 0.0, right: 0.0)
    }

    private func setupView() {
        imageView?.layer.cornerRadius = 5.0
        imageView?.clipsToBounds = true
    }

    func configure(with: AppIconViewController.AppIcon) {
        // ...
    }
}
