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

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var stateView: StateView = {
        let view = StateView()
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        // TODO: move these into class property?
        let spacing: CGFloat = 8.0
        // TODO: should there be a max width?
        let stateViewWidth = frame.width - spacing * 2.0
        let stateViewHeight = frame.height - spacing * 2.0
        stateView.frame = CGRect(x: spacing, y: spacing, width: stateViewWidth, height: stateViewHeight)
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(imageView)
        addSubview(stateView)
    }

    // MARK: - Actions

    private func didPressRetry() {
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
        stateView.render(viewState)
        if case .result(let image) = viewState {
            UIView.animate(withDuration: 0.3, animations: {
                self.stateView.isHidden = true
                self.imageView.image = image
            })
        } else {
            stateView.isHidden = false
            imageView.image = nil
        }
    }
}

// MARK: - Themeable
extension ImageCell: Themeable {
    func apply(theme: AppTheme) {
        stateView.apply(theme: theme)
    }
}
