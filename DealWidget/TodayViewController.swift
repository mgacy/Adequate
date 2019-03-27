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

    private var currentDealManager: CurrentDealManager!
    private var viewState: ViewState<CurrentDeal> = .empty {
        didSet {
            render(viewState)
        }
    }

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
        currentDealManager = CurrentDealManager()
        loadDeal { _ in }
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
        compactConstraints = [
            // imageView
            imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -spacing),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacing),
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: spacing)
        ]

        // Expanded
        expandedConstraints = [
            // imageView
            imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -spacing),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: spacing),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing)
        ]

        // Shared
        // TODO: can we always count on 1:1 aspect ratio?
        // see: https://www.raywenderlich.com/1169-easier-auto-layout-coding-constraints-in-ios-9
        let imageWidthConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 800.0)

        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: spacing),
            imageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: spacing),
            imageWidthConstraint,
            // stackView
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -spacing),
            //stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -spacing)
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
            titleLabel.preferredMaxLayoutWidth = maxSize.width - maxSize.height - (2.0 * spacing)
            preferredContentSize = maxSize
        case .expanded:
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(expandedConstraints)
            titleLabel.preferredMaxLayoutWidth = maxSize.width - (2.0 * spacing)
            titleLabel.setNeedsUpdateConstraints()
            let height = maxSize.width + (spacing * 2.0) + titleLabel.intrinsicContentSize.height + priceLabel.intrinsicContentSize.height
            preferredContentSize = CGSize(width: maxSize.width, height: min(height, maxSize.height))
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        loadDeal { error in
            if error == nil {
                /*
                // TODO: check if data differs from current?
                if case .result(let currentDeal) = self.viewState {
                    print("Current viewState: \(currentDeal)")
                }
                */
                completionHandler(.newData)
            } else {
                print("ERROR: \(error!)")
                completionHandler(.failed)
            }
        }
    }

    // MARK: - B

    func loadDeal(completionHandler: @escaping (Error?) -> Void) {
        viewState = .loading
        guard let deal = currentDealManager.readDeal() else {
            viewState = .error(WidgetError.missingDeal)
            return completionHandler(WidgetError.missingDeal)
        }

        //titleLabel.text = deal.title
        //priceLabel.text = deal.maxPrice != nil ? "$\(deal.minPrice) - \(deal.maxPrice!)" : "$\(deal.minPrice)"

        guard let dealImage = currentDealManager.readImage() else {
            viewState = .error(WidgetError.missingImage)
            return completionHandler(WidgetError.missingImage)
        }

        imageView.image = dealImage

        viewState = .result(deal)
    }

}

// MARK: - ViewStateRenderable
extension TodayViewController: ViewStateRenderable {
    typealias ResultType = CurrentDeal

    func render(_ viewState: ViewState<CurrentDeal>) {
        switch viewState {
        case .empty:
            print("Empty")
        case .loading:
            print("Loading ...")
            titleLabel.text = "--"
            priceLabel.text = "--"
        case .result(let deal):
            print("Deal: \(deal)")
            titleLabel.text = deal.title
            priceLabel.text = deal.maxPrice != nil ? "$\(deal.minPrice) - \(deal.maxPrice!)" : "$\(deal.minPrice)"
        case .error(let error):
            print("Error: \(error)")
            titleLabel.text = "-*-"
            priceLabel.text = "-*-"
        }
    }
}

// MARK: - A

// TODO: move to CurrentDealManager?
public enum WidgetError: Error {
    case missingManager
    case missingDeal
    case missingImage
}
