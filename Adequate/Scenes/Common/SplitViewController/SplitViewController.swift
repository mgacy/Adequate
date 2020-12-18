//
//  SplitViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

/// In contrast to `UISplitViewController`, which manages child view controllers in a _hierarchical_ interface, this
/// class is intended to present an alternative arrangement of elements that are presented together.
class SplitViewController: UIViewController {

    // TODO: add optional delegate and if provided, call that instead of `primaryChild`?

    var primaryChild: UIViewController & PrimaryViewControllerType

    /// Value of top directional edge inset applied to `primaryChild` when layout margins are updated.
    var defaultTopInsetForChild: CGFloat = 0.0

    /// Value of the bottom directional edge inset applied to `primaryChild` when layout margins are updated.
    var defaultBottomInsetForChild: CGFloat = 0.0

    // FIXME: the fact that we continue to use same set of `regularConstraints` means this needs to remain the same
    // view throughout lifetime of of view controller. Should we maintain reference and replace
    // `separateSecondaryView() -> UIView?` with `willRemoveSecondaryView()`?
    /// We will hold a reference to the secondaryView when we have regular horizontal size class
    weak var secondaryView: UIView? // TODO: add setter which inserts below primaryChild?
    //    didSet {
    //        if let newView = secondaryView {
    //            view.insertSubview(newView, belowSubview: primaryChild.view)
    //        }
    //    }
    //}

    var rotationManager: RotationManaging?

    override var navigationItem: UINavigationItem {
        return primaryChild.navigationItem
    }

    // MARK: Constraints

    private lazy var secondaryColumnGuide = UILayoutGuide()

    private lazy var secondaryColumnConstraints: [NSLayoutConstraint] = {
        return [
            secondaryColumnGuide.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            secondaryColumnGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            secondaryColumnGuide.trailingAnchor.constraint(equalTo: primaryChild.view.leadingAnchor),
            secondaryColumnGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()

    /// Constraints for regular horizontal trait collection irrespective of orientation.
    private lazy var regularConstraints: [NSLayoutConstraint] = {
        // TODO: combine `secondaryColumnConstraints` with this?
        return primaryChild.configureConstraints(with: secondaryColumnGuide, in: view)
    }()

    /// Constraint determining relative width of primary and secondary columns.
    private lazy var primaryWidthConstraint: NSLayoutConstraint = {
        primaryChild.view.widthAnchor.constraint(equalTo: view.widthAnchor)
    }()

    // TODO: look at `UISplitViewController.preferredSupplementaryColumnWidthFraction` for ideas

    // TODO: add minimum / maximum column widths that would override fractional width multiplier?

    /// Relative width of left column for regular-width size class in portrait orientation.
    private let portraitWidthMultiplier: CGFloat = Constants.portraitRatio

    /// Relative width of right column for regular-width size class in landscape orientation.
    private let landscapeWidthMultiplier: CGFloat = Constants.landscapeRatio

    /// Flag indicating whether initial configuration has been completed.
    private var initialSetupDone = false

    /// Store layout before disappearing so that on reappearing, controller can adjust to any layout changes that
    /// happened in the interim.
    private var layoutBeforeDisappearing: SplitLayout?

    // MARK: - Lifecycle

    init(primaryChild: UIViewController & PrimaryViewControllerType) {
        self.primaryChild = primaryChild
        // Set `defaultTopInsetForChild`, `defaultBottomInsetForChild` from current values of `primaryChild.view`?
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    override func loadView() {
        if let backgroundView = primaryChild.makeBackgroundView() {
            // FIXME: this doesn't currently work because `StateView.render(_:)` hides itself for `ViewState.result`
            backgroundView.translatesAutoresizingMaskIntoConstraints = true
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.frame = UIScreen.main.bounds
            view = backgroundView
        } else {
            super.loadView()
        }
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update for rotations / trait collection changes that happened while view was not visible
        guard let previousLayout = layoutBeforeDisappearing else { return }
        layoutBeforeDisappearing = nil

        // FIXME: this solution is pretty specific to our usage with DealViewController in a page view controller. Of
        // course, the problem we are trying to solve might also be pretty specific to that situation. Perhaps this is
        // better addressed at the level of the `RootPageViewController` or another specialized object.
        guard let newLayout = navigationController?.parent?.layout, newLayout != previousLayout else {
            return
        }

        transition(from: previousLayout, to: newLayout)
    }

    override func viewWillDisappear(_ animated: Bool) {
        layoutBeforeDisappearing = SplitLayout(traitCollection: traitCollection, frame: view.frame)
        super.viewWillDisappear(animated)
    }

    //deinit { print("\(#function) - \(self.description)") }

    // MARK: - View Methods

    func setupView() {
        view.backgroundColor = .systemBackground
        add(primaryChild)

        // Force compact-wdth size class?
        //setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: .compact), forChild: primaryChild)

        if let backgroundView = primaryChild.makeBackgroundView() {
            view.insertSubview(backgroundView, at: 0)
        }
        setupConstraints()
    }

    private func setupConstraints() {
        primaryChild.view.translatesAutoresizingMaskIntoConstraints = false
        view.addLayoutGuide(secondaryColumnGuide)
        NSLayoutConstraint.activate([
            primaryChild.view.topAnchor.constraint(equalTo: view.topAnchor),
            primaryChild.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            primaryChild.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UIContentContainer
extension SplitViewController {

    // MARK: Trait Collection

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.willTransition(to: newCollection, with: coordinator)

        // TODO: at some size, the accessibility `UIContentSizeCategory` cases should trigger an layout change as
        // 2 columns don't make sense at small--but still regular--sizes.

        // If app starts in split screen, this method will be called for changes from `UIUserInterfaceLevel.base` to
        // `.elevated` before the view has been loaded and `setupView()` has been called.
        guard isViewLoaded else {
            return
        }

        let oldCollection = traitCollection
        coordinator.animate(
            alongsideTransition: { [unowned self] _ in
                switch (oldCollection.horizontalSizeClass, newCollection.horizontalSizeClass) {
                case (.compact, .regular):
                    // TODO: pass context?
                    self.transitionToRegular()
                case (.regular, .compact):
                    // TODO: pass context?
                    self.transitionToCompact()
                case (.regular, .regular):
                    break
                case (.compact, .compact):
                    break
                default:
                    break
                }
            },
            completion: nil
        )
    }

    // MARK: - Rotation

    /// NOTE: this is called after `UIViewController.willTransition(to:with:)` when both are called
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        rotationManager?.beforeRotation()
        coordinator.animate(
            alongsideTransition: { [unowned self] (context) -> Void in
                // If we are changing size classes, this will already be the new size class
                if self.traitCollection.horizontalSizeClass == .regular {
                    // TODO: add check that width of primary column would be > min threshold
                    // TODO: just pass `size` to another method?
                    if size.width > size.height {
                        self.updateWidth(for: .regularLandscape)
                    } else {
                        self.updateWidth(for: .regularPortrait)
                    }
                    self.view.layoutIfNeeded()
                //} else if self.traitCollection.horizontalSizeClass == .compact {
                }
                self.rotationManager?.alongsideRotation(context)
            },
            completion: { [unowned self] (context) -> Void in
                self.rotationManager?.completeRotation(context)
            }
        )
    }
}

// MARK: - Layout
extension SplitViewController {

    override func viewWillLayoutSubviews() {
        if !initialSetupDone {
            switch traitCollection.horizontalSizeClass {
            case .compact:
                primaryWidthConstraint.isActive = true
                if let secondaryView = primaryChild.separateSecondaryView() { // This is kinda ugly
                    primaryChild.collapseSecondaryView(secondaryView)
                }
            case .regular:
                transitionToRegular()
                if view.frame.width > view.frame.height {
                    updateWidth(for: .regularLandscape)
                } else {
                    updateWidth(for: .regularPortrait)
                }
            default:
                log.error("Unexpected horizontalSizeClass: \(traitCollection.horizontalSizeClass)")
            }
            initialSetupDone = true
        }
    }

    // This is called before `.viewWillLayoutSubviews()`
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        // Communicate changes in leading margin to primary child
        // TODO: should we add a custom property to control this behavior?
        let newMargins = view.directionalLayoutMargins
        primaryChild.view.directionalLayoutMargins = .init(top: defaultTopInsetForChild,
                                                           leading: newMargins.leading,
                                                           bottom: defaultBottomInsetForChild,
                                                           trailing: newMargins.trailing)
    }
}

// MARK: - Layout Helpers
extension SplitViewController {

    // TODO: rename
    private func updateWidth(for layout: SplitLayout) {
        switch layout {
        case .compact:
            primaryWidthConstraint = primaryWidthConstraint.changeMultiplier(multiplier: 1.0)
        case .regularLandscape:
            primaryWidthConstraint = primaryWidthConstraint.changeMultiplier(multiplier: landscapeWidthMultiplier)
        case .regularPortrait:
            primaryWidthConstraint = primaryWidthConstraint.changeMultiplier(multiplier: portraitWidthMultiplier)
        }
    }

    private func transition(from previous: SplitLayout, to new: SplitLayout) {
        switch (previous, new) {
        case (.compact, .regularPortrait):
            transitionToRegular()
            updateWidth(for: new)
        case (.compact, .regularLandscape):
            transitionToRegular()
            updateWidth(for: new)
        case (.regularPortrait, .compact):
            transitionToCompact()
        case (.regularLandscape, .compact):
            transitionToCompact()
        case (.regularLandscape, .regularPortrait):
            updateWidth(for: new)
        case (.regularPortrait, .regularLandscape):
            updateWidth(for: new)
        default:
            return
        }
    }

    /// Transition from regular to compact-width size class.
    private func transitionToCompact() {
        NSLayoutConstraint.deactivate(secondaryColumnConstraints)
        NSLayoutConstraint.deactivate(regularConstraints)

        if let secondaryView = self.secondaryView {
            secondaryView.removeFromSuperview()
            primaryChild.collapseSecondaryView(secondaryView)
            self.secondaryView = nil
        }
        updateWidth(for: .compact)
    }

    /// Transition from compact to regular-width size class.
    ///
    /// **NOTE**: calls to this method must be followed by call to `updateWidth(for:)` to reactivate
    /// `primaryWidthConstraint` with appropriate multiplier.
    private func transitionToRegular() {
        if let secondaryView = primaryChild.separateSecondaryView() {
            secondaryView.removeFromSuperview()  // `primaryChild` should have done this, but better safe
            view.insertSubview(secondaryView, belowSubview: primaryChild.view)
            self.secondaryView = secondaryView
        }

        // We have to momentarily disable `primaryWidthConstraint` before activating `secondaryColumnConstraints` to
        // avoid conflict with leading and trailing anchors of `secondaryColumnGuide`. It will be reactivated when
        // `viewWillTransition(to:with:)` calls `updateWidth(for:)` and we mutate the multiplier of
        // `primaryWidthConstraint`.
        // TODO: lower priority rather than deactivate, then restore in `updateWidth(for:)`?
        primaryWidthConstraint.isActive = false

        NSLayoutConstraint.activate(secondaryColumnConstraints)
        NSLayoutConstraint.activate(regularConstraints)
    }
}

// MARK: - Supporting Types
extension SplitViewController {

    enum Constants {
        static var landscapeRatio: CGFloat = 1.0 / 3.0
        static var portraitRatio: CGFloat = 1.0 / 2.0
    }
}
