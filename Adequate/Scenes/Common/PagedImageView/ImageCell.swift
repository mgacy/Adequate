//
//  ImageCell.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/11/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

// MARK: - Delegate

protocol ImageCellDelegate: class {
    func retry(imageURL: URL) -> Promise<UIImage>
}

// MARK: - Cell

class ImageCell: UICollectionViewCell {

    // MARK: - A
    weak var delegate: ImageCellDelegate?
    var imageURL: URL!
    private var invalidatableQueue = InvalidatableQueue()
    private var viewState: ViewState<UIImage> {
        didSet {
            render(viewState)
        }
    }

    // MARK: - Subviews

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
        viewState = .empty
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
        viewState = .empty
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(imageView)
        addSubview(activityIndicator)
        addSubview(retryButton)
        retryButton.addTarget(self, action: #selector(didPressRetry(_:)), for: .touchUpInside)
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

    // MARK: - Actions

    @objc private func didPressRetry(_ sender: UIButton) {
        // FIXME: this doesn't look right
        guard delegate != nil else {
            return
        }
        viewState = .loading
        delegate?.retry(imageURL: imageURL)
            .then(on: invalidatableQueue, { [weak self] image in
                self?.viewState = .result(image)
            }).catch({ [weak self] error in
                log.warning("IMAGE ERROR: \(error)")
                self?.viewState = .error(error)
            })
    }

    // MARK: - Configuration

    func configure(with image: UIImage) {
        viewState = .result(image)
    }

    func configure(with promise: Promise<UIImage>) {
        if let imageValue = promise.value {
            viewState = .result(imageValue)
            return
        }
        viewState = .loading
        promise.then(on: invalidatableQueue, { [weak self] image in
            self?.viewState = .result(image)
        }).catch({ [weak self] error in
            log.warning("IMAGE ERROR: \(error)")
            self?.viewState = .error(error)
        })
    }

}

// MARK: - ViewStateRenderable
extension ImageCell: ViewStateRenderable {
    typealias ResultType = UIImage

    func render(_ viewState: ViewState<ResultType>) {
        switch viewState {
        case .empty:
            activityIndicator.stopAnimating()
            imageView.image = nil
            retryButton.isHidden = true
        case .loading:
            activityIndicator.startAnimating()
            //imageView.image = nil
            retryButton.isHidden = true
        case .result(let image):
            activityIndicator.stopAnimating()
            imageView.image = image
            //retryButton.isHidden = true
        case .error:
            activityIndicator.stopAnimating()
            //imageView.image = nil
            retryButton.isHidden = false
        }
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
