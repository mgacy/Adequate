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

    private var themeManager: ThemeManagerType
    private var observationTokens: [ObservationToken] = []
    private var pages = [UIViewController]()

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

    func setupView() {
        view.backgroundColor = .white
        self.dataSource = self
        /*
        // pageControl
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        let tintColor = UIButton().tintColor
        pageControl.pageIndicatorTintColor = tintColor?.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = tintColor
        */
    }

    func setupObservations() -> [ObservationToken] {
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
    }

}

// MARK: - UIPageViewControllerDataSource
extension RootPageViewControler: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                return nil
            } else {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.index(of: viewController) {
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

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentVC = viewControllers?.first, let currentIndex = pages.index(of: currentVC) {
            return currentIndex
        } else {
            return 0
        }
    }
    */

}

// MARK: - B
// https://stackoverflow.com/a/45667644/4472195
extension RootPageViewControler {

    func goToNextPage(animated: Bool = true) {
        guard let currentVC = viewControllers?.first else { return }
        guard let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC) else { return }
        setViewControllers([nextVC], direction: .forward, animated: animated, completion: nil)
        /*
        // Has to be set like this, since else the delgates for the buttons won't work
        // https://stackoverflow.com/a/52312012/4472195
        setViewControllers([nextVC], direction: .forward, animated: animated) { completed in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [],
                                               transitionCompleted: completed)
        }
        */
    }

    func goToPreviousPage(animated: Bool = true) {
        guard let currentVC = viewControllers?.first else { return }
        guard let previousVC = dataSource?.pageViewController(self, viewControllerBefore: currentVC) else { return }
        setViewControllers([previousVC], direction: .reverse, animated: animated, completion: nil)
        /*
        // Has to be set like this, since else the delgates for the buttons won't work
        // https://stackoverflow.com/a/52312012/4472195
        setViewControllers([previousVC], direction: .reverse, animated: animated) { completed in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [],
                                               transitionCompleted: completed)
        }
        */
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
