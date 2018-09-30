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

        setupConstraints()
    }

    private func setupConstraints() {
        //NSLayoutConstraint.activate([])
    }

}
