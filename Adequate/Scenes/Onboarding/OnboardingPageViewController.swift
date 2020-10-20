//
//  OnboardingPageViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/25/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    typealias Dependencies = HasNotificationManager & HasUserDefaultsManager

    let dependencies: Dependencies
    var pages = [UIViewController]()
    weak var dismissalDelegate: VoidDismissalDelegate?

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        // TODO: create dataSource here?
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private func setupView() {
        self.dataSource = self

        let page1 = WelcomeViewController()
        let page2 = NotificationViewController(dependencies: dependencies)
        page2.delegate = self

        self.pages.append(page1)
        self.pages.append(page2)
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)

        apply(theme: .system)
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                return nil
            } else {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                return self.pages[viewControllerIndex + 1]
            } else {
                return nil
            }
        }
        return nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentVC = viewControllers?.first, let currentIndex = pages.firstIndex(of: currentVC) {
            return currentIndex
        } else {
            return 0
        }
    }
}

// MARK: - VoidDismissalDelegate
extension OnboardingPageViewController: VoidDismissalDelegate {

    func dismiss() {
        dismissalDelegate?.dismiss()
    }
}

// MARK: - Themeable
extension OnboardingPageViewController: Themeable {

    func apply(theme: ColorTheme) {
        view.backgroundColor = theme.systemBackground

        let pageControlAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControlAppearance.currentPageIndicatorTintColor = theme.tint
        pageControlAppearance.pageIndicatorTintColor = theme.tertiaryTint

        pages.compactMap { $0 as? Themeable }.forEach { $0.apply(theme: theme) }
    }
}
