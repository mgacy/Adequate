//
//  AcknowledgementsViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/30/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Down

class AcknowledgementsViewController: UIViewController {
    //typealias Dependencies = HasThemeManager

    //private let themeManager: ThemeManagerType
    //private var observationTokens: [ObservationToken] = []

    // TODO: use Style instead
    private let VerticalMargin: CGFloat = 16.0
    private let HorizontalMargin: CGFloat = 8.0

    // MARK: - Subviews

    private lazy var textView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = false
        view.dataDetectorTypes = .link
        view.textContainerInset = UIEdgeInsets.init(top: VerticalMargin, left: HorizontalMargin,
                                                    bottom: VerticalMargin, right: HorizontalMargin)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.addSubview(textView)
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    /// Called to notify the view controller that its view has just laid out its subviews.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Set the textView text after layout completion for automatic content inset adjustment
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let acknowledgementsString = self?.loadAcknowledgements()
            DispatchQueue.main.async { [weak self] in
                self?.textView.attributedText = acknowledgementsString
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = .white
        //observationTokens = setupObservations()
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0.0),
            textView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0.0),
            textView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0.0),
            textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0.0)
        ])
    }
    /*
    private func setupObservations() -> [ObservationToken] {
        let themeToken = themeManager.addObserver(self)
        return [themeToken]
    }
    */
    // MARK: - A

    private func loadAcknowledgements() -> NSAttributedString? {
        guard
            let path = Bundle.main.path(forResource: "Pods-Adequate-acknowledgements", ofType: "markdown"),
            let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
                log.error("Error getting Acknowledgements")
                return nil
        }
        let down = Down(markdownString: content)
        return try? down.toAttributedString()
    }

}
/*
// MARK: - Themeable
extension AcknowledgementsViewController: Themeable {
    func apply(theme: AppTheme) {
        // accentColor
        // backgroundColor
        view.backgroundColor = theme.backgroundColor
        textView.backgroundColor = theme.backgroundColor
        // foreground
        textView.textColor = theme.foreground.textColor
    }
}
*/
