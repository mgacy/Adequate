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

protocol ImageCellDelegate: AnyObject {
    func retry(imageURL: URL) -> Promise<UIImage>
}

// MARK: - Cell

final class ImageCell: UICollectionViewCell, AsyncCellConfigurable {

    // MARK: - A
    weak var delegate: ImageCellDelegate?
    var modelID: URL?
    private var invalidatableQueue = InvalidatableQueue()
    private(set) var viewState: ViewState<UIImage> {
        didSet {
            render(viewState)
        }
    }

    // MARK: - Subviews

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    // TODO: subclass UIImageView and add relevant subviews
    private lazy var stateView: StateView = {
        let view = StateView(frame: frame)
        view.emptyMessageText = ""
        view.loadingMessageText = nil
        view.onRetry = { [weak self] in
            self?.didPressRetry()
        }
        return view
    }()

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
        modelID = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        stateView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }

    //deinit {
    //    invalidatableQueue.invalidate()
    //}

    // MARK: - Configuration

    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(stateView)
    }

    // MARK: - Actions

    private func didPressRetry() {
        guard let delegate = delegate, let imageURL = modelID else {
            return
        }
        viewState = .loading
        delegate.retry(imageURL: imageURL)
            .then(on: invalidatableQueue, { [weak self] image in
                self?.viewState = .result(image)
            }).catch({ [weak self] error in
                log.warning("IMAGE ERROR: \(error)")
                self?.viewState = .error(error)
            })
    }
}

// MARK: - CellConfigurable
extension ImageCell: CellConfigurable {

    func configure(with promise: Promise<UIImage>) {
        if let imageValue = promise.value {
            viewState = .result(imageValue)
            return
        } else if let error = promise.error {
            log.warning("IMAGE ERROR: \(error)")
            viewState = .error(error)
            return
        }
        viewState = .loading
        promise.then(on: invalidatableQueue, { [weak self] image in
            // TODO: ideally, we would want to compare URL of fetched resource to modelID
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
        stateView.render(viewState)
        if case .result(let image) = viewState {
            stateView.isHidden = true
            imageView.image = image
        } else {
            stateView.isHidden = false
            imageView.image = nil
        }
    }
}

// MARK: - Themeable
extension ImageCell: Themeable {
    func apply(theme: ColorTheme) {
        stateView.apply(theme: theme)
    }
}
