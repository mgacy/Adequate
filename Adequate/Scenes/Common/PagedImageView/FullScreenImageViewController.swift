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
    // TODO: replace with pure reliance on `dataSource`
    private let imageSource: Promise<UIImage>
    private let dataSource: PagedImageViewDataSourceType

    /// Maintain a strong reference to `transitioningDelegate`
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
        view.color = .secondaryLabel // or .white?
        view.isHidden = true
        return view
    }()

    private lazy var zoomingImageView: ZoomingImageView = {
        let view = ZoomingImageView()
        //let view = ZoomingImageView(frame: UIScreen.main.bounds)
        return view
    }()

    // TODO: should I just make this the root view?
    lazy var blurredView: UIView = {
        let blurEffect: UIBlurEffect
        blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
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

    deinit { print("\(#function) - \(self.description)") }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = .clear

        view.addSubview(activityIndicator)
        view.addSubview(zoomingImageView)
        view.addSubview(closeButton)
        view.insertSubview(blurredView, at: 0)

        //zoomingImageView.zoomingImageDelegate = self
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
        blurredView.frame = view.frame
        activityIndicator.center = view.center // TODO: center relative to view or safe area?
        zoomingImageView.frame = view.frame

        // TODO: move to `ViewMetrics` type?
        let x = view.bounds.width - view.safeAreaInsets.left - 2 * 28.0
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

// MARK: - Transition
// TODO: Specify as conformance to a new protocol; move method to default implementation?
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
        if let transitionImage = imageSource.value {
            let transitionImageView = UIImageView(image: transitionImage)
            transitionImageView.contentMode = .scaleAspectFit
            //transitionImageView.frame = originFrame
            return transitionImageView
        } else {
            let transitionImageView = UIView(frame: originFrame)
            transitionImageView.backgroundColor = .red
            //transitionImageView.frame = originFrame
            return transitionImageView
        }
    }
}
