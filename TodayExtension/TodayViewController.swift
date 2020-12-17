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

class TodayViewController: UIViewController {

    private var currentDealManager: CurrentDealManager!
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = 2
        // TODO: handle locale?
        return formatter
    }()

    private var viewState: ViewState<ResultType> = .empty {
        didSet {
            render(viewState)
        }
    }

    private var compactConstraints: [NSLayoutConstraint] = []
    private var expandedConstraints: [NSLayoutConstraint] = []

    // MARK: - Subviews

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Style.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = Style.primaryTextColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
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

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapWidget(_:)))
        return recognizer
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currentDealManager = CurrentDealManager()
        loadDeal { _ in }
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDeal { _ in }
    }

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

    // MARK: - View Setup

    func setupView() {
        view.addGestureRecognizer(tapRecognizer)
        view.addSubview(imageView)
        view.addSubview(stackView)
        setupConstraints()

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


        guard let activeDisplayMode = extensionContext?.widgetActiveDisplayMode else {
            fatalError("Unable to get extensionContext")
        }
        switch activeDisplayMode {
        case .compact:
            NSLayoutConstraint.activate(compactConstraints)
        case .expanded:
            NSLayoutConstraint.activate(expandedConstraints)
        @unknown default:
            fatalError("Unrecognized activeDisplayMode")
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

    @objc func didTapWidget(_ sender: UITapGestureRecognizer) {
        guard let appURL = URL(string: "adequate:deal") else {
            return
        }
        extensionContext?.open(appURL, completionHandler: nil)
    }

}

// MARK: - NCWidgetProviding
extension TodayViewController: NCWidgetProviding {

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
        @unknown default:
            fatalError("Unrecognized activeDisplayMode")
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

}

// MARK: - ViewStateRenderable
extension TodayViewController: ViewStateRenderable {
    typealias ResultType = DealWrapper

    func render(_ viewState: ViewState<ResultType>) {
        switch viewState {
        case .empty:
            titleLabel.text = ""
            priceLabel.text = ""
            // TODO: add resource for placeholder
            imageView.image = nil
        case .loading:
            titleLabel.text = "--"
            priceLabel.text = "--"
            // TODO: what about imageView?
            // TODO: use placeholder
        case .result(let wrapper):
            let deal = wrapper.deal
            titleLabel.text = deal.title
            let formattedMinPrice = formatter.string(from: deal.minPrice as NSNumber) ?? "\(deal.minPrice)"
            if let maxPrice = deal.maxPrice {
                let formattedMaxPrice = formatter.string(from: maxPrice as NSNumber) ?? "\(maxPrice)"
                priceLabel.text = "$\(formattedMinPrice) - \(formattedMaxPrice)"
            } else {
                priceLabel.text = "$\(formattedMinPrice)"
            }
            imageView.image = wrapper.image
            // TODO: indicate if deal is soldOut
        case .error(let error):
            print("Error: \(error)")
            titleLabel.text = "-*-"
            priceLabel.text = "-*-"
            // TODO: add resource for error
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
// TODO: use ColorTheme (or AppTheme?)
enum Style {
    static let cornerRadius: CGFloat = 8.0
    // Colors
    static let primaryTextColor = UIColor.label
    static let secondaryTextColor = UIColor.secondaryLabel
    // Layout
    static let spacing: CGFloat = 8.0
}
