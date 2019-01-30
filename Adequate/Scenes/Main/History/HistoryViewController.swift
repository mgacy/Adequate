//
//  HistoryViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/13/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {
    typealias Dependencies = HasThemeManager

    weak var delegate: VoidDismissalDelegate?

    private let themeManager: ThemeManagerType

    // MARK: - Subviews

    // ...

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.themeManager = dependencies.themeManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        //let view = UIView()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self,
                                                           action: #selector(didPressDismiss(_:)))
        //self.view = view
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
        view.backgroundColor = .white

        if let theme = themeManager.theme {
            apply(theme: theme)
        }
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        let sideMargin: CGFloat = 16.0
        //NSLayoutConstraint.activate([
        //])
    }

    // MARK: - A

    @objc func didPressDismiss(_ sender: UIBarButtonItem) {
        delegate?.dismiss()
    }

    // TODO: handle cell selection

}

// MARK: - Themeable
extension HistoryViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        // ...

        // backgroundColor
        view.backgroundColor = theme.backgroundColor

        // foreground
        // ...
    }
}
