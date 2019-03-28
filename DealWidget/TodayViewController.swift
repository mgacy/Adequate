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
    private var viewState: ViewState<ResultType> = .empty {
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
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = Style.secondaryTextColor
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
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ...
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // ...
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // ...
    }
    */
    deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - View Setup

    func setupView() {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        titleLabel.text = "--"
        priceLabel.text = "--"
    }

    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        // Compact
        compactConstraints = [
            // imageView
            imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -Style.spacing),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Style.spacing),
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Style.spacing)
        ]

        // Expanded
        expandedConstraints = [
            // imageView
            imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Style.spacing),
            // stackView
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Style.spacing),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Style.spacing)
        ]

        // Shared
        // TODO: can we always count on 1:1 aspect ratio?
        // see: https://www.raywenderlich.com/1169-easier-auto-layout-coding-constraints-in-ios-9
        let imageWidthConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 800.0)

        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Style.spacing),
            imageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Style.spacing),
            imageWidthConstraint,
            // stackView
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Style.spacing)
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
        switch activeDisplayMode {
        case .compact:
            NSLayoutConstraint.deactivate(expandedConstraints)
            NSLayoutConstraint.activate(compactConstraints)
            titleLabel.preferredMaxLayoutWidth = maxSize.width - maxSize.height - (2.0 * Style.spacing)
            preferredContentSize = maxSize
        case .expanded:
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(expandedConstraints)
            titleLabel.preferredMaxLayoutWidth = maxSize.width - (2.0 * Style.spacing)
            titleLabel.setNeedsUpdateConstraints()
            let height = maxSize.width + (2.0 * Style.spacing) + titleLabel.intrinsicContentSize.height + priceLabel.intrinsicContentSize.height
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
            viewState = .error(CurrentDealManagerError.missingDeal)
            return completionHandler(CurrentDealManagerError.missingDeal)
        }
        let dealImage = currentDealManager.readImage()
        viewState = .result(DealWrapper(deal: deal, image: dealImage))
    }

}

// MARK: - ViewStateRenderable
extension TodayViewController: ViewStateRenderable {
    typealias ResultType = DealWrapper

    func render(_ viewState: ViewState<ResultType>) {
        switch viewState {
        case .empty:
            titleLabel.text = ""
            priceLabel.text = ""
            imageView.image = nil
        case .loading:
            titleLabel.text = "--"
            priceLabel.text = "--"
            // TODO: what about imageView?
        case .result(let wrapper):
            let deal = wrapper.deal
            titleLabel.text = deal.title
            priceLabel.text = deal.maxPrice != nil ? "$\(deal.minPrice) - \(deal.maxPrice!)" : "$\(deal.minPrice)"
            imageView.image = wrapper.image
        case .error(let error):
            print("Error: \(error)")
            titleLabel.text = "-*-"
            priceLabel.text = "-*-"
            imageView.image = nil
        }
    }
}

// MARK: - Model
struct DealWrapper {
    let deal: CurrentDeal
    let image: UIImage?
}

// MARK: - Style
enum Style {
    // Colors
    static let secondaryTextColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.00)
    // Layout
    static let spacing: CGFloat = 8.0
}
