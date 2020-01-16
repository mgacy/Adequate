//
//  ZoomingImageView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class ZoomingImageView: UIScrollView {

    weak var zoomingImageDelegate: ZoomingImageViewDelegate?
    var imageView: UIImageView = UIImageView()

    var originFrame: CGRect {
        return CGRect(x: imageView.frame.minX - contentOffset.x,
                      y: imageView.frame.minY - contentOffset.y,
                      width: imageView.frame.width,
                      height: imageView.frame.height)
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateOffsetForSize()
    }

    // MARK: - Configuration

    private func configure() {
        // scrollView
        bouncesZoom = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self

        // imageView
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        configureDoubleTap()
    }

    private func configureDoubleTap() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2

        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(doubleTapRecognizer)
    }

    // MARK: - Public

    func updateImageView(with newImage: UIImage) {
        imageView.image = newImage

        let imageSize = newImage.size
        imageView.frame = CGRect(origin: .zero, size: imageSize)
        contentSize = imageSize

        updateZoomScale()
        updateOffsetForSize()
    }

    // MARK: - Private

    @objc private func handleDoubleTap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            if zoomScale == minimumZoomScale {
                setZoomScale(1.0, animated: true)
            } else {
                setZoomScale(minimumZoomScale, animated: true)
            }
        }
    }

    func updateZoomScale() {
        let imageSize = imageView.image?.size ?? CGSize(width: 1, height: 1)
        //let imageSize = imageView.bounds.size
        let viewSize = bounds.size

        let widthScale = viewSize.width / imageSize.width
        let heightScale = viewSize.height / imageSize.height

        let minScale = min(widthScale, heightScale)
        minimumZoomScale = minScale
        zoomScale = minScale
    }

    // TODO: pass CGSize?
    private func updateOffsetForSize() {
        //let imageSize = imageView.image?.size ?? CGSize(width: 1, height: 1)
        let viewSize = bounds.size

        let offsetX = (viewSize.width > contentSize.width) ? (viewSize.width - contentSize.width) / 2 : 0
        let offsetY = (viewSize.height > contentSize.height) ? (viewSize.height - contentSize.height) / 2 : 0

        imageView.center = CGPoint(x: offsetX + (contentSize.width / 2), y: offsetY + (contentSize.height / 2))
    }
}

// MARK: - UIScrollViewDelegate
extension ZoomingImageView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateOffsetForSize()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        zoomingImageDelegate?.scrollViewDidUpdate(scrollView)
    }
}
