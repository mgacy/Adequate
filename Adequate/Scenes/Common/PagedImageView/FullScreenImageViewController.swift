//
//  FullScreenImageViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

final class FullScreenImageViewController: UIViewController {

    weak var delegate: FullScreenImageDelegate?
    private let imageSource: Promise<UIImage>
    private let dataSource: PagedImageViewDataSourceType

    // Maintain a strong reference to `transitioningDelegate`
    private var transitionController: FullScreenImageTransitionController?

    private var initialSetupDone = false

    // MARK: - Appearance

    //var hideStatusBar: Bool = false
    //override var prefersStatusBarHidden: Bool {
    //    return hideStatusBar
    //}

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Subviews

    private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "CloseNavBar"), for: .normal)
        button.layer.cornerRadius = 14.0
        button.imageEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        button.tintColor = .white
        button.backgroundColor = ColorPalette.darkGray
        button.alpha = 0.0
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .secondaryLabel
        view.isHidden = true
        return view
    }()

    private lazy var zoomingImageView: ZoomingImageView = {
        let view = ZoomingImageView()
        //let view = ZoomingImageView(frame: UIScreen.main.bounds)
        //view.zoomingImageDelegate = self
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    lazy var blurredView: UIView = {
        let blurEffect: UIBlurEffect
        blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    // MARK: - Lifecycle

    init(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath) {
        self.dataSource = dataSource
        self.imageSource = dataSource.imageSource(for: indexPath)
        super.init(nibName: nil, bundle: nil)
        //view.frame = UIScreen.main.bounds
        self.overrideUserInterfaceStyle = .dark
        self.modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.closeButton.alpha = 1.0
        })
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeButton.alpha = 0.0
    }

    //deinit { print("\(#function) - \(self.description)") }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = .clear

        zoomingImageView.frame = view.frame
        blurredView.frame = view.frame

        view.addSubview(activityIndicator)
        view.addSubview(zoomingImageView)
        view.addSubview(closeButton)
        view.insertSubview(blurredView, at: 0)

        closeButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)

        // image
        if imageSource.isPending {
            activityIndicator.startAnimating()
        }
        imageSource.then({ [weak self] image in
            self?.zoomingImageView.updateImageView(with: image)
        }).catch({ error in
            log.error("\(#function): \(error)")
        }).always({ [weak self] in
            self?.activityIndicator.stopAnimating()
        })
    }

    // MARK: - Actions

    @objc private func dismissView(_ sender: UIButton) {
        delegate?.dismissFullScreenImage()
    }
}

// MARK: - Layout
extension FullScreenImageViewController {

    override func viewWillLayoutSubviews() {
        activityIndicator.center = view.center

        // TODO: move to `ViewMetrics` type?
        // swiftlint:disable:next identifier_name
        let x = view.bounds.width - view.safeAreaInsets.left - 2 * 28.0
        // swiftlint:disable:next identifier_name
        let y: CGFloat
        switch view.safeAreaInsets.top {
        case 0.0..<24.0:
            y = view.safeAreaInsets.top + 8.0
        default:
            y = view.safeAreaInsets.top
        }
        closeButton.frame = CGRect(x: x, y: y, width: 28.0, height: 28.0)
    }

    override func viewDidLayoutSubviews() {
        if !initialSetupDone {
            zoomingImageView.updateZoomScale()
            initialSetupDone = true
        }
    }
}

// MARK: - UIContentContainer
extension FullScreenImageViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { [weak zoomingImageView] _ in
                zoomingImageView?.updateZoomScale()
                zoomingImageView?.updateOffsetForSize()
            },
            completion: nil
        )
    }
}

// MARK: - Transition
extension FullScreenImageViewController {

    func setupTransitionController(animatingFrom fromDelegate: ViewAnimatedTransitioning) {
        modalPresentationStyle = .overFullScreen
        transitionController = FullScreenImageTransitionController(presenting: self, from: fromDelegate, to: self)
        transitioningDelegate = transitionController
    }
}

// MARK: - ViewAnimatedTransitioning
extension FullScreenImageViewController: ViewAnimatedTransitioning {

    var originFrame: CGRect {
        return view.convert(zoomingImageView.originFrame, to: nil)
    }

    var originView: UIView {
        return zoomingImageView.imageView
    }

    func makeTransitioningView() -> UIView? {
        let transitionImageView: UIView
        if let transitionImage = imageSource.value {
            transitionImageView = UIImageView(image: transitionImage)
            transitionImageView.contentMode = .scaleAspectFit
        } else {
            transitionImageView = LoadingView(frame: originFrame)
        }
        return transitionImageView
    }
}
