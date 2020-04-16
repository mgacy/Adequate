//
//  PriceFormatter.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/14/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

// MARK: - Protocol
protocol PriceFormatting {
    func parsePriceData(from: Deal) throws -> (priceText: String, priceComparison: String?)
}

// TODO: should this handle localization-specifc concerns?
final class PriceFormatter: PriceFormatting {

    typealias PriceData = (priceText: String, priceComparison: String?)

    // MARK: - Properties

    // TODO: handle `$29.97 (for 3) at Amazon`, etc
    // TODO: handle `51.49 @ Walmart`
    // TODO: use `#""" ... """#` so we can avoid the additional escape characters
//    private let priceComparisonPattern = """
//        \\[
//        (\\\\)? # Older specs looked like `[\\$199 at Walmart]`
//        (?<price>\\$[0-9.]*)
//        \\s.*at\\s
//        (?<store>.*)
//        \\]
//        \\(
//        (?<link>https://w{3}\\..*)
//        \\)
//        """

    private let priceComparisonPattern = ##"""
        \[
        (\\)? # Older specs looked like `[\$199 at Walmart]`
        (?<price>\$[0-9.]*)
        \s.*at\s
        (?<store>.*)
        \]
        \(
        (?<link>https://w{3}\..*)
        \)
        """##

    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = 2
        // TODO: handle locale?
        return formatter
    }()

    // MARK: - Interface

    func parsePriceData(from deal: Deal) throws -> PriceData {
        let priceText = (parsePriceRange >>> formatPriceRange)(deal)
        let priceComparison = try parsePriceComparison(from: deal.specifications)
            .flatMap { formatPriceComparison($0) }
        return (priceText: priceText, priceComparison: priceComparison)
    }

    // MARK: - Parsers

    private func parsePriceRange(for deal: Deal) -> PriceRange {
        let minQuantity = Double(deal.purchaseQuantity?.minimumLimit ?? 1)
        let prices = deal.items.map { $0.price * minQuantity }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return .none
        }
        if minPrice == maxPrice {
            return .single(minPrice)
        } else {
            return .range(min: minPrice, max: maxPrice)
        }
    }

    private func parsePriceComparison(from text: String) throws -> PriceComparison? {
        let regexOptions: NSRegularExpression.Options = [.allowCommentsAndWhitespace]

        let regex = try NSRegularExpression(pattern: priceComparisonPattern, options: regexOptions)
        return regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)).flatMap { match in
            guard
                let priceSubString = text.substring(with: match.range(withName: "price")),
                let storeSubString = text.substring(with: match.range(withName: "store")),
                let urlSubString = text.substring(with: match.range(withName: "link")),
                let url = URL(string: String(describing: urlSubString)) else {
                    return nil
            }
            return PriceComparison(price: String(describing: priceSubString),
                                   store: String(describing: storeSubString),
                                   url: url)
        }
    }

    // MARK: - Formatters

    private func formatPriceComparison(_ priceComparison: PriceComparison) -> String {
        // TODO: handle localization (including price conversion?)
        return "\(priceComparison.price) at \(priceComparison.store)"
    }

    // TODO: add extension to NumberFormatter to handle `formatter.string(from: price as NSNumber) ?? "\(price)"`
    private func formatPriceRange(_ priceRange: PriceRange) -> String {
        switch priceRange {
        case .none:
            return "ERROR: missing price"
        case .single(let price):
            let formattedMinPrice = formatter.string(from: price as NSNumber) ?? "\(price)"
            return "$\(formattedMinPrice)"
        case .range(let minPrice, let maxPrice):
            let formattedMinPrice = formatter.string(from: minPrice as NSNumber) ?? "\(minPrice)"
            let formattedMaxPrice = formatter.string(from: maxPrice as NSNumber) ?? "\(maxPrice)"
            return "$\(formattedMinPrice) - $\(formattedMaxPrice)"
        }
    }
}

// MARK: - C

import UIKit

class FooterViewController: UIViewController {

    private lazy var formatter: PriceFormatting = PriceFormatter()

    // TODO: replace delegate with simple closure
    weak var delegate: DealFooterDelegate?
    //var buttonTapHandler: (() -> Void)?

    // MARK: - Subviews

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorCompatibility.label
        label.font = FontBook.compactFooter
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceComparisonLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorCompatibility.secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [priceLabel, priceComparisonLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let buyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = FontBook.boldButton
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitle(L10n.buy, for: .normal)
        button.setTitle(L10n.soldOut, for: .disabled)
        button.setTitleColor(button.tintColor, for: .normal)
        button.layer.cornerRadius = 5 // FIXME: use standard corner radius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorCompatibility.systemBackground
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceStack, buyButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0 // FIXME: isn't this pretty arbitrary?
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    //required init?(coder aDecoder: NSCoder) {
    //    fatalError("init(coder:) has not been implemented")
    //}

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    func setupView() {
        buyButton.addTarget(self, action: #selector(buy(_:)), for: .touchUpInside)
        buyButton.isHidden = true
        view.addSubview(stackView)
        //layer.mask = gradientMaskLayer
        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: guide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func buy(_ sender: UIButton) {
        delegate?.buy()
        //buttonTapHandler?()
    }
}

// MARK: - Layout
extension FooterViewController {

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        // FIXME: get values for margins from a central source; move into a type?
        let bottomLayoutMargin: CGFloat = view.safeAreaInsets.bottom > 8.0 ? 0.0 : 8.0
        guard let parentMargins = parent?.view.layoutMargins else {
            return
        }
        view.layoutMargins = UIEdgeInsets(top: 8.0,
                                          left: parentMargins.left,
                                          bottom: bottomLayoutMargin,
                                          right: parentMargins.right)
    }
}

// MARK: - ViewStateRenderable
extension FooterViewController: ViewStateRenderable {
    typealias ResultType = Deal

    func render(_ viewState: ViewState<Deal>) {
        switch viewState {
        case .empty:
            view.isHidden = true
        case .loading:
            view.isHidden = true
        case .result(let deal):
            do {
                let priceData: PriceFormatter.PriceData
                priceData =  try formatter.parsePriceData(from: deal)

                // Price Comparison
                if let priceComparison = priceData.priceComparison {
                    priceComparisonLabel.text = priceComparison
                    priceComparisonLabel.isHidden = false
                    //stackView.alignment = .center
                    priceLabel.font = FontBook.compactFooter
                } else {
                    priceComparisonLabel.isHidden = true
                    //stackView.alignment = .firstBaseline
                    priceLabel.font = FontBook.expandedFooter
                }

                // LaunchStatus
                let launchStatus = deal.launchStatus ?? (deal.soldOutAt == nil ? .launch : .soldOut)
                updateStatus(launchStatus: launchStatus, priceText: priceData.priceText)
            } catch  {
                log.error("Unable to parse price data: \(error)")
                render(.error(error))
            }
        case .error:
            // TODO: is this the best way to handle?
            view.isHidden = true
        }
    }

    // MARK: Helpers

    private func updateStatus(launchStatus: LaunchStatus, priceText: String) {
        buyButton.isHidden = false

        switch launchStatus {
        case .launch, .relaunch:
            buyButton.isEnabled = true
            priceLabel.isHidden = false
            priceLabel.removeStrikethrough()
            priceLabel.text = priceText
        case .launchSoldOut:
            buyButton.isEnabled = false
            priceLabel.isHidden = false
            priceLabel.setStrikethrough(text: priceText)
            // TODO: show button to schedule reminder for when relaunch occurs
        case .relaunchSoldOut:
            buyButton.isEnabled = false
            priceLabel.isHidden = false
            priceLabel.setStrikethrough(text: priceText)
        case .soldOut:
            buyButton.isEnabled = false
            priceLabel.isHidden = false
            priceLabel.setStrikethrough(text: priceText)
        case .expired:
            priceLabel.isHidden = true
            // TODO: display with strikethrough or different color?
            //priceLabel.text = priceText
        case .unknown(_):
            log.error("Unknown LaunchStatus: \(launchStatus)")
            // FIXME: how to handle?
            priceLabel.isHidden = true
        }
    }
}

// MARK: - Themeable
extension FooterViewController: Themeable {
    func apply(theme: ColorTheme) {
        priceLabel.textColor = theme.label
        priceComparisonLabel.textColor = theme.secondaryLabel

        view.backgroundColor = theme.secondarySystemBackground

        buyButton.setTitleColor(theme.secondarySystemBackground, for: .normal)
        buyButton.setTitleColor(ColorCompatibility.systemBlue, for: .selected)
        buyButton.backgroundColor = theme.tint
    }
}
