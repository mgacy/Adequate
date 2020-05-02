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
    let imageSource: Promise<UIImage>
    private let dataSource: PagedImageViewDataSourceType

    // TODO: rename `interactionController?
    /// Maintain a strong reference to `transitioningDelegate`
    private var transitionController: FullScreenImageTransitionController?

    private var initialSetupDone = false

    // MARK: - Appearance

    var backgroundColor: UIColor = .black

    var hideStatusBar: Bool = false
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    //override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    //    return .slide
    //}

    // MARK: - Subviews

    private var closeButton: UIButton = {
        //let button = UIButton(frame: CGRect(x: 30.0, y: 30.0, width: 30.0, height: 30.0))
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "CloseNavBar"), for: .normal)
        button.layer.cornerRadius = 14.0
        button.imageEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        button.tintColor = .white
        button.backgroundColor = ColorPalette.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var zoomingImageView: ZoomingImageView = {
        let view = ZoomingImageView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath) {
        self.dataSource = dataSource
        self.imageSource = dataSource.imageSource(for: indexPath)
        super.init(nibName: nil, bundle: nil)
        view.frame = UIScreen.main.bounds
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // hide status bar
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            window.windowLevel = UIWindow.Level.statusBar + 1
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // show status bar
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            window.windowLevel = UIWindow.Level.normal
        }
    }

    deinit { print("\(#function) - \(self.description)") }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = backgroundColor

        view.addSubview(activityIndicator)
        view.addSubview(zoomingImageView)
        view.addSubview(closeButton)
        setupConstraints()

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

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // closeButton
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28.0),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            closeButton.widthAnchor.constraint(equalToConstant: 28.0),
            closeButton.heightAnchor.constraint(equalToConstant: 28.0),
            // zoomingImageView
            zoomingImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            zoomingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            zoomingImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            zoomingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
    }

    // MARK: - B


    @objc private func dismissView(_ sender: UIButton) {
        delegate?.dismissFullScreenImage()
    }
}

// MARK: - Layout
extension FullScreenImageViewController {

    override func viewDidLayoutSubviews() {
        if !initialSetupDone {
            zoomingImageView.updateZoomScale()
            initialSetupDone = true
        }
    }
}

// MARK: - Transition
// TODO: Specify as conformance to a new protocol(?)
extension FullScreenImageViewController {

    // TODO: make  protocol; move to default implementation(?)
    func setupTransitionController(animatingFrom fromDelegate: ViewAnimatedTransitioning) {
        modalPresentationStyle = .overFullScreen
        //transitionController = MyTransitionController(presenting: self, from: fromDelegate, to: self)
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
