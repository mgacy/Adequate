//
//  StoryViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/30/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Down

final class StoryViewController: UIViewController {
    typealias Dependencies = HasThemeManager

    let story: Story
    let themeManager: ThemeManagerType

    // MARK: - View

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyText: MDTextView = {
        let view = MDTextView(stylesheet: Appearance.stylesheet)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, bodyText])
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(story: Story, depenedencies: Dependencies) {
        self.story = story
        self.themeManager = depenedencies.themeManager
        super.init(nibName: nil, bundle: nil)
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - View Methods

    private func setupView() {
        navigationItem.title = "Story"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        titleLabel.text = story.title
        bodyText.markdown = story.body

        if let theme = themeManager.theme {
            apply(theme: theme)
        }

        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        //let spacing: CGFloat = 16.0
        let sideMargin: CGFloat = 16.0
        let widthInset: CGFloat = -2.0 * sideMargin

        NSLayoutConstraint.activate([
            // scrollView
            scrollView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sideMargin),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: widthInset),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

}

// MARK: - Themeable
extension StoryViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        // ...

        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        bodyText.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor

        // foreground
        titleLabel.textColor = theme.foreground.textColor
        bodyText.textColor = theme.foreground.textColor
    }
}
