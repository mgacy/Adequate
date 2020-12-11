//
//  AcknowledgementsViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/30/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Down

final class AcknowledgementsViewController: UIViewController {
    typealias Dependencies = HasThemeManager

    private let themeManager: ThemeManagerType
    private var observationTokens: [ObservationToken] = []

    var styler: MDStyler

    // MARK: - Subviews

    private lazy var textView: MDTextView = {
        let view = MDTextView(styler: styler)
        view.isScrollEnabled = true
        view.dataDetectorTypes = .link
        view.contentInsetAdjustmentBehavior = .automatic
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.themeManager = dependencies.themeManager
        self.styler = MDStyler()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    private func setupView() {
        view.addSubview(textView)
        setupConstraints()
        observationTokens = setupObservations()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let acknowledgementsString = self?.loadAcknowledgements()
            DispatchQueue.main.async { [weak self] in
                self?.textView.markdownText = acknowledgementsString
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupObservations() -> [ObservationToken] {
        let themeToken = themeManager.addObserver(self)
        return [themeToken]
    }

    // MARK: - A

    private func loadAcknowledgements() -> String? {
        guard
            let path = Bundle.main.path(forResource: "Pods-Adequate-acknowledgements", ofType: "markdown"),
            let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
                log.error("Error getting Acknowledgements")
                return nil
        }
        return content
    }
}

// MARK: - Layout
extension AcknowledgementsViewController {

    override func viewLayoutMarginsDidChange() {
        textView.textContainerInset = view.layoutMargins
    }
}

// MARK: - ThemeObserving
extension AcknowledgementsViewController: ThemeObserving {

    func apply(theme: AppTheme) {
        apply(theme: theme.dealTheme ?? theme.baseTheme)
    }
}

// MARK: - Themeable
extension AcknowledgementsViewController: Themeable {

    func apply(theme: ColorTheme) {
        // backgroundColor
        view.backgroundColor = theme.systemBackground
        textView.backgroundColor = theme.systemBackground

        styler.colors = MDColorCollection(theme: theme)
        try? textView.render()
    }
}
