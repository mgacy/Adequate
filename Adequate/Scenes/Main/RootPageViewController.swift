//
//  RootPageViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/21/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

enum RootViewControllerPage {
    case deal
    case history
    case story
}

final class RootPageViewControler: UIPageViewController {
    typealias Dependencies = HasThemeManager

    private(set) var currentIndex: Int = 0

    private var themeManager: ThemeManagerType
    private var observationTokens: [ObservationToken] = []
    private var pages = [UIViewController]()

    override var childForStatusBarStyle: UIViewController? {
        return pages[currentIndex]
    }

    // MARK: - Lifecycle

    init(depenedencies: Dependencies) {
        self.themeManager = depenedencies.themeManager
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal,
                   options: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observationTokens = setupObservations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = .white
        self.dataSource = self
        self.delegate = self

        // Set self as delegate for page view controller's scroll view
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break
            }
        }

        /*
        // pageControl
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        let tintColor = UIButton().tintColor
        pageControl.pageIndicatorTintColor = tintColor?.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = tintColor
        */
    }

    private func setupObservations() -> [ObservationToken] {
        return [themeManager.addObserver(self)]
    }

    func setPages(_ viewControllers: [UIViewController], displayIndex: Int, animated: Bool = false) {
        guard 0 <= displayIndex, displayIndex <= viewControllers.count - 1 else {
            fatalError("displayIndex \(displayIndex) out of range")
        }

        pages = []
        viewControllers.forEach { viewController in
            pages.append(viewController)
        }
        setViewControllers([viewControllers[displayIndex]], direction: .forward, animated: animated, completion: nil)
        currentIndex = displayIndex
    }
}

// MARK: - UIPageViewControllerDataSource
extension RootPageViewControler: UIPageViewControllerDataSource {

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

     // Page Indicator Support
    /*
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
     */
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentVC = viewControllers?.first, let currentIndex = pages.firstIndex(of: currentVC) {
            return currentIndex
        } else {
            return 0
        }
    }
}

// MARK: - UIPageViewDelegate
extension RootPageViewControler: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard
                let viewController = pageViewController.viewControllers?.first,
                let index = pages.firstIndex(of: viewController) else {
                    fatalError("Can't prevent bounce if there's not an index")
            }
            currentIndex = index
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}

// MARK: - B
// https://stackoverflow.com/a/45667644/4472195
extension RootPageViewControler {

    func goToNextPage(animated: Bool = true) {
        guard let currentVC = viewControllers?.first else { return }
        guard let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC) else { return }
        setViewControllers([nextVC], direction: .forward, animated: animated) { completed in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentVC],
                                               transitionCompleted: completed)
        }
    }

    func goToPreviousPage(animated: Bool = true) {
        guard let currentVC = viewControllers?.first else { return }
        guard let previousVC = dataSource?.pageViewController(self, viewControllerBefore: currentVC) else { return }
        setViewControllers([previousVC], direction: .reverse, animated: animated) { completed in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentVC],
                                               transitionCompleted: completed)
        }
    }

}

// MARK: - UIScrollViewDelegate - Disable Bounce
// https://stackoverflow.com/a/25167681
extension RootPageViewControler: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if (currentIndex == pages.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }

    /**
     Deal with a bug when the user quickly swipes from left to right at the 1st page; the 1st page won't bounce at the
     left (due to the function above), but will bounce at the right caused by the (maybe) velocity of the swipe.
     When bounced back, the UIPageViewController will trigger an unexpected page flip to the 2nd page.
     */
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (currentIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if (currentIndex == pages.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }

}

// MARK: - Themeable
extension RootPageViewControler: Themeable {
    func apply(theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor

        // Apply to children
        //pages.compactMap { $0 as? Themeable }.forEach { $0.apply(theme: theme) }
    }
}
