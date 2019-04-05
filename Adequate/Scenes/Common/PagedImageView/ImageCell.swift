//
//  ImageCell.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/11/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class ImageCell: UICollectionViewCell {

    // MARK: - A
    var imageURL: URL!
    var invalidatableQueue = InvalidatableQueue()

    // MARK: - Interface

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// TOODO: errorView

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        invalidatableQueue.invalidate()
        invalidatableQueue = InvalidatableQueue()
        imageView.image = nil
        activityIndicator.stopAnimating()
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(imageView)
        addSubview(activityIndicator)
        addSubview(retryButton)
        retryButton.isHidden = true
        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            // retryButton
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Configuration

    func configure(with image: UIImage) {
        imageView.image = image
    }

    func configure(with promise: Promise<UIImage>) {
        if let image = promise.value {
            imageView.image = image
            return
        }
        activityIndicator.startAnimating()
        promise.then(on: invalidatableQueue, { [weak self] image in
            self?.imageView.image = image
        }).catch({ error in
            log.warning("IMAGE ERROR: \(error)")
            /// TODO: display errorView
        }).always ({ [weak self] in
            self?.activityIndicator.stopAnimating()
        })
    }

}

// MARK: - Themeable
extension ImageCell: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        // backgroundColor
        // foreground
        switch theme.foreground {
        case .dark:
            activityIndicator.style = .gray
            //retryButton.layer.borderColor = UIColor.gray.cgColor
            //retryButton.setTitleColor(.gray, for: .normal)
        case .light:
            activityIndicator.style = .white
            //retryButton.layer.borderColor = UIColor.gray.cgColor
            //retryButton.setTitleColor(.gray, for: .normal)
        case .unknown:
            break
        }
    }
}
