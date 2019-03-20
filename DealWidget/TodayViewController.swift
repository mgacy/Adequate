//
//  TodayViewController.swift
//  DealWidget
//
//  Created by Mathew Gacy on 3/15/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import NotificationCenter

// https://stackoverflow.com/questions/26037321/how-to-create-a-today-widget-programmatically-without-storyboard-on-ios8
@objc (TodayViewController)

class TodayViewController: UIViewController, NCWidgetProviding {

    private var compactConstraints: [NSLayoutConstraint] = []
    private var expandedConstraints: [NSLayoutConstraint] = []

    // MARK: - Subviews

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        view.addSubview(imageView)
        view.addSubview(stackView)
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
        
    // MARK: - View Setup

    func setupView() {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        titleLabel.text = "--"
        priceLabel.text = "--"
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        // TODO: move these into class property
        let spacing: CGFloat = 8.0
        //let sideMargin: CGFloat = 16.0
        //let widthInset: CGFloat = -2.0 * sideMargin

        // Compact
        compactConstraints.append(contentsOf: [
            // imageView
            imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -spacing),
            //imageView.widthAnchor.constraint(equalToConstant: imageView.heightAnchor),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacing),
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: spacing)
        ])

        // Expanded
        expandedConstraints.append(contentsOf: [
            // imageView
            imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -spacing),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: spacing),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing)
        ])

        // Shared
        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: spacing),
            imageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: spacing),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            // stackView
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -spacing),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -spacing)
        ])

        switch extensionContext?.widgetActiveDisplayMode {
        case .compact?:
            NSLayoutConstraint.activate(compactConstraints)
        case .expanded?:
            NSLayoutConstraint.activate(expandedConstraints)
        case .none:
            fatalError("Unable to get extensionContext")
        }
    }

    // MARK: - NCWidgetProviding

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let spacing: CGFloat = 8.0

        switch activeDisplayMode {
        case .compact:
            NSLayoutConstraint.deactivate(expandedConstraints)
            NSLayoutConstraint.activate(compactConstraints)

            //preferredContentSize = widgetMaximumSize(for: .compact)
            preferredContentSize = CGSize(width: maxSize.width, height: 200)
        case .expanded:
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(expandedConstraints)

            //let height = maxSize.width + spacing + stackView.intrinsicContentSize.height + spacing
            let height = maxSize.width + (spacing * 2.0) + titleLabel.intrinsicContentSize.height + priceLabel.intrinsicContentSize.height
            preferredContentSize = CGSize(width: maxSize.width, height: min(height, maxSize.height))
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
