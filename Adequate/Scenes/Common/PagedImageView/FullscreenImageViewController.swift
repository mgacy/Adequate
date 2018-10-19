//
//  FullscreenImageViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

class FullScreenImageViewController: UIViewController {

    weak var delegate: FullscreenImageDelegate?
    let imageSource: Promise<UIImage>
    let originFrame: CGRect

    private let panGestureRecognizer = UIPanGestureRecognizer()
    /// TODO: rename `interactionController?
    private var transitionController: FullscreenImageTransitionController?

    // MARK: - Appearance

    var backgroundColor: UIColor = .black

    // MARK: - Subviews

    private var closeButton: UIButton = {
        //let button = UIButton(frame: CGRect(x: 30.0, y: 30.0, width: 30.0, height: 30.0))
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "CloseGlyph"), for: .normal)
        button.layer.cornerRadius = 15.0
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var zoomingImageView: ZoomingImageView = {
        let view = ZoomingImageView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(imageSource: Promise<UIImage>, originFrame: CGRect) {
        self.imageSource = imageSource
        self.originFrame = originFrame
        super.init(nibName: nil, bundle: nil)
        //view.frame = UIScreen.main.bounds
        self.modalPresentationStyle = .custom
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
        view.frame = UIScreen.main.bounds
        view.backgroundColor = backgroundColor

        // zoomingImageView
        //zoomingImageView.zoomingImageDelegate = self
        view.addSubview(zoomingImageView)

        // activityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = true

        // closeButton
        closeButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        view.addSubview(closeButton)

        setupConstraints()
        setupTransitionController()

        // image
        if imageSource.isPending {
            activityIndicator.startAnimating()
        }
        imageSource.then({ [weak self] image in
            self?.zoomingImageView.updateImageView(with: image)
        }).catch({ error in
            print("ERROR: \(error)")
        }).always({ [weak self] in
            self?.activityIndicator.stopAnimating()
        })
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // closeButton
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0),
            closeButton.widthAnchor.constraint(equalToConstant: 30.0),
            closeButton.heightAnchor.constraint(equalToConstant: 30.0),
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

    private func setupTransitionController() {
        transitionController = FullscreenImageTransitionController(viewController: self, originFrame: originFrame)
        transitioningDelegate = transitionController
    }

    // MARK: - B

    @objc private func dismissView(_ sender: UIButton) {
        delegate?.dismissFullscreenImage()
    }

}
