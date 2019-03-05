//
//  HistoryDetailViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {
    typealias Dependencies = HasThemeManager

    weak var delegate: VoidDismissalDelegate?

    private let themeManager: ThemeManagerType
    private var deal: Deal

    private var viewState: ViewState<Deal> {
        didSet {
            render(viewState)
        }
    }

    private let panGestureRecognizer = UIPanGestureRecognizer()
    /// TODO: rename `interactionController?
    private var transitionController: SlideTransitionController?

    // MARK: - Subviews

    private lazy var dismissButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .stop, target: self,
                               action: #selector(didPressDismiss(_:)))
    }()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let pagedImageView: PagedImageView = {
        let view = PagedImageView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        //label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let featuresText: MDTextView = {
        let label = MDTextView(stylesheet: Appearance.stylesheet)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let storyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Story", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    private let forumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Comments", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = button.tintColor
        return button
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies, deal: Deal) {
        self.themeManager = dependencies.themeManager
        self.deal = deal
        self.viewState = .empty
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        //super.loadView()
        let view = UIView()

        view.addSubview(scrollView)
        scrollView.addSubview(pagedImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(featuresText)
        navigationItem.leftBarButtonItem = dismissButton

        self.view = view
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    func setupView() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
        //forumButton.addTarget(self, action: #selector(didPressForum(_:)), for: .touchUpInside)
        //storyButton.addTarget(self, action: #selector(didPressStory(_:)), for: .touchUpInside)

        apply(theme: themeManager.theme)
        viewState = .result(deal)
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        let spacing: CGFloat = 8.0
        let sideMargin: CGFloat = 16.0
        let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // scrollView
            scrollView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            // pagedImageView
            pagedImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            pagedImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacing),
            pagedImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            pagedImageView.heightAnchor.constraint(equalTo: pagedImageView.widthAnchor, constant: 32.0),
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            titleLabel.topAnchor.constraint(equalTo: pagedImageView.bottomAnchor, constant: spacing),
            titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            // featuresLabel
            featuresText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            featuresText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            featuresText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            featuresText.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing)
            ])
    }

    private func setupTransitionController() {
        transitionController = SlideTransitionController(transitionType: .panel, viewController: self)
        transitioningDelegate = transitionController
    }

    // MARK: - Navigation
    /*
    @objc private func didPressForum(_ sender: UIButton) {
        guard let deal = deal, let topic = deal.topic else {
            return
        }
        delegate?.showForum(with: topic)
    }

    @objc private func didPressStory(_ sender: UIButton) {
        guard let deal = deal else {
            return
        }
        delegate?.showStory(with: deal.story)
    }
    */
    // ...

    @objc private func didPressDismiss(_ sender: UIBarButtonItem) {
        delegate?.dismiss()
    }

}

// MARK: - ViewState
extension HistoryDetailViewController {
    func render(_ viewState: ViewState<Deal>) {
        switch viewState {
        case .empty:
            return
        case .error(let error):
            print("\(error.localizedDescription)")
        case .loading:
            return
        case .result(let deal):
            titleLabel.text = deal.title
            featuresText.markdown = deal.features
            // images
            let safePhotoURLs = deal.photos.compactMap { $0.secure() }
            pagedImageView.updateImages(with: safePhotoURLs)
        }
    }

    }
}

// MARK: - Themeable
extension HistoryDetailViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        storyButton.backgroundColor = theme.accentColor
        forumButton.backgroundColor = theme.accentColor

        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        pagedImageView.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor
        featuresText.backgroundColor = theme.backgroundColor
        storyButton.setTitleColor(theme.backgroundColor, for: .normal)
        forumButton.setTitleColor(theme.backgroundColor, for: .normal)

        // foreground
        /// TODO: set status bar and home indicator color?
        titleLabel.textColor = theme.foreground.textColor
        featuresText.textColor = theme.foreground.textColor

        // Subviews
        pagedImageView.apply(theme: theme)
    }
}

// MARK: - A

class SlideTransitionController: NSObject {

    // New
    enum TransitionType {
        case fullscreenImage
        case panel
    }
    private var transitionType: TransitionType = .fullscreenImage
    // /New

    //var originFrame: CGRect
    weak var viewController: UIViewController!
    var interacting: Bool = false

    // Pan down transitions back to the presenting view controller
    var interactionController: UIPercentDrivenInteractiveTransition?

    lazy private var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        recognizer.delegate = self

        // Avoid unexpected behavior when touch event occurs near edge of screen
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()

    // MARK: - Lifecycle

    init(transitionType: TransitionType, viewController: UIViewController) {
        self.viewController = viewController
        self.transitionType = transitionType
        //self.originFrame = CGRect(x: 0, y: 0, width: 0, height: 0) // TEMP
        super.init()
        viewController.view.addGestureRecognizer(panGestureRecognizer)
    }

    deinit { print("\(#function) - \(self.description)") }

    // MARK: - A

    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let percent = translation.y / gesture.view!.bounds.size.height

        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            viewController.dismiss(animated: true)

            /// https://stackoverflow.com/a/50238562/4472195
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.interactionController?.update(percent)
            }
        case .changed:
            interactionController?.update(percent)
        case .ended:
            let velocity = gesture.velocity(in: gesture.view)
            /// https://stackoverflow.com/a/42972283/1271826
            interactionController?.completionSpeed = 0.999
            if (percent > 0.5 && velocity.y >= 0) || velocity.y > 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            return
        }
    }

}

// MARK: - UIGestureRecognizerDelegate
extension SlideTransitionController: UIGestureRecognizerDelegate {

    // Recognize downward gestures only
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = pan.translation(in: pan.view)
            let angle = atan2(translation.y, translation.x)
            return abs(angle - .pi / 2.0) < (.pi / 8.0)
        }
        return false
    }

}

// MARK: - UIViewControllerTransitioningDelegate
extension SlideTransitionController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //return ZoomInAnimationController(sourceFrame: originFrame)
        switch transitionType {
        case .fullscreenImage:
            // cast as FullScreenImageViewController for now?
            guard let vc = viewController as? FooAnimating else {
                fatalError("ERROR: failed to cast as correct view controllers for transition")
            }
            return ZoomInAnimationController(sourceFrame: vc.originFrame)
        case .panel:
            return PanelAnimationController(transitionType: .presenting)
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //return ZoomOutAnimationController(sourceFrame: originFrame)
        switch transitionType {
        case .fullscreenImage:
            // cast as FullScreenImageViewController for now?
            guard let vc = viewController as? FooAnimating else {
                fatalError("ERROR: failed to cast as correct view controllers for transition")
            }
            return ZoomInAnimationController(sourceFrame: vc.originFrame)
        case .panel:
            return PanelAnimationController(transitionType: .dismissing)
        }
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    // MARK: New

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch transitionType {
        case .fullscreenImage:
            return nil
        case .panel:
            return SheetPresentationController(presentedViewController: presented, presenting: presenting)
        }
    }

}

// MARK: - Z

protocol FooAnimating {
    var originFrame: CGRect { get }
}

protocol ImageSource {
    //var visibleImage:
}

// MARK: - A

// [robertmryan](https://github.com/robertmryan)
// [robertmryan/SwiftCustomTransitions](https://github.com/robertmryan/SwiftCustomTransitions/tree/rightside)
// FIXME: the above are under a Creative Commons License
// https://stackoverflow.com/a/42213998/4472195
class SheetPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return false }

    var dimmerView: UIView!
    //private var dimmerAlphaComponent: Float = 0.2
    //private var dimmerBackgroundColor: UIColor = black.withAlphaComponent(0.2)

    override func presentationTransitionWillBegin() {
        guard
            let transitionCoordinator = presentingViewController.transitionCoordinator,
            let `containerView` = containerView else {
                //log.error("\(#function) FAILED : unable get transitionCoordinator or containerView"); return
                print("\(#function) FAILED : unable get transitionCoordinator or containerView"); return

        }

        dimmerView = UIView(frame: containerView.bounds)
        dimmerView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmerView.alpha = 0
        containerView.addSubview(dimmerView)
        transitionCoordinator.animate(alongsideTransition: { _ in self.dimmerView.alpha = 1 }, completion: nil)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmerView.removeFromSuperview()
            dimmerView = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            //log.error("\(#function) FAILED : unable get transitionCoordinator"); return
            print("\(#function) FAILED : unable get transitionCoordinator"); return
        }
        transitionCoordinator.animate(alongsideTransition: { _ in self.dimmerView.alpha = 0 }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmerView.removeFromSuperview()
            dimmerView = nil
        }
    }

}

// MARK: - B

class PanelAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    enum TransitionType {
        case presenting
        case dismissing
    }

    let transitionType: TransitionType

    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        switch transitionType {
        case .presenting:
            animatePresentation(from: fromVC, to: toVC, using: transitionContext)
        case .dismissing:
            animateDismissal(from: fromVC, to: toVC, using: transitionContext)
        }
    }

    // MARK: - Present / Dismiss

    private func animatePresentation(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        // TODO
        let dy = containerView.frame.size.height
        let finalFrame = transitionContext.finalFrame(for: toVC)

        //log.debug("\(#function): \(fromVC) -> \(toVC) in \(containerView)")

        toVC.view.frame = finalFrame.offsetBy(dx: 0.0, dy: dy)
        containerView.addSubview(toVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIView.AnimationOptions.curveEaseOut ],
            animations: {
                toVC.view.frame = finalFrame
        },
            completion: { _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled) }
        )
    }

    private func animateDismissal(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let dy = containerView.frame.size.height
        let initialFrame = fromVC.view.frame

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = initialFrame.offsetBy(dx: 0.0, dy: dy)
        }, completion: { _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled) }
        )
    }

}
