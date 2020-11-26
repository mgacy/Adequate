//
//  LoadingView.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/25/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    // MARK: - Subviews

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //private lazy var imageView: UIImageView = {
    //    let view = UIImageView()
    //    view.contentMode = contentMode
    //    return view
    //}()

    // MARK: - Lifecycle

    //convenience init(frame: CGRect, contentMode: ContentMode = .scaleAspectFit) {
    //    self.init(frame: frame)
    //    self.contentMode = contentMode
    //}

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
        overrideUserInterfaceStyle = .dark
        layer.cornerRadius = 8.0
        backgroundColor = .systemGray2

        addSubview(activityIndicator)
        setupConstraints()
        activityIndicator.startAnimating()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
