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

    let story: Story

    // MARK: - View

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 12.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(story: Story) {
        self.story = story
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
        navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
    }

    // MARK: - View Methods

    private func setupView() {
        navigationItem.title = "Story"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        // Story
        titleLabel.text = story.title

        let down = Down(markdownString: story.body)
        let attributedString = try? down.toAttributedString(.smart, stylesheet: Appearance.styleSheet)
        bodyLabel.attributedText = attributedString

        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        /// TODO: move these into class property?
        let spacing: CGFloat = 14.0
        let sideMargin: CGFloat = 14.0
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
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacing),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

}
