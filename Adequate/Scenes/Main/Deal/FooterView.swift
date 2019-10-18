//
//  FooterView.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/2/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Delegate

protocol DealFooterDelegate: class {
    func buy()
}

// MARK: - View

class FooterView: UIView {

    weak var delegate: DealFooterDelegate?
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = 2
        // TODO: handle locale?
        return formatter
    }()
    //private var priceText: String = ""

    // MARK: - Appearance

    private let horizontalInset: CGFloat = 16.0

    // MARK: - Subviews

    private var bottomAnchorConstraint: NSLayoutConstraint!

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
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorCompatibility.systemBackground
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceStack, buyButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // iPhone X - Portraint: 34.0 / Landscape: 21.0
        bottomAnchorConstraint.constant = safeAreaInsets.bottom > 10.0 ? 0.0 : -8.0
    }

    // MARK: - Configuration

    private func configure() {
        buyButton.addTarget(self, action: #selector(buy(_:)), for: .touchUpInside)
        buyButton.isHidden = true
        addSubview(stackView)
        setupConstraints()
    }

    private func setupConstraints() {
        bottomAnchorConstraint = stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalInset),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: horizontalInset / 2.0),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalInset),
            bottomAnchorConstraint
        ])
    }

    // MARK: - Actions

    @objc private func buy(_ sender: UIButton) {
        delegate?.buy()
    }
}

// MARK: - Update View
extension FooterView {

    // FIXME: shouldn't really have model communicating directly with view
    public func update(withDeal deal: Deal) {

        // Price Comparison
        if let priceComparison = parsePriceComparison(from: deal.specifications) {
            priceComparisonLabel.text = formatPriceComparison(priceComparison)
            priceComparisonLabel.isHidden = false
            //stackView.alignment = .center
            priceLabel.font = FontBook.compactFooter
        } else {
            log.debug("Unable to parse price comparison")
            priceComparisonLabel.isHidden = true
            //stackView.alignment = .firstBaseline
            priceLabel.font = FontBook.expandedFooter
        }

        // Format price
        let priceText: String = (parsePriceRange >>> formatPriceRange)(deal)

        // LaunchStatus
        // Handle soldOut in case launchStatus is not implemented
        let launchStatus = deal.launchStatus ?? (deal.soldOutAt == nil ? .launch : .soldOut)

        updateStatus(launchStatus: launchStatus, priceText: priceText)
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

    // TODO: make throwing?
    private func parsePriceComparison(from text: String) -> PriceComparison? {
        // TODO: relocate pattern to PriceComparisonParser object
        // TODO: handle `$29.97 (for 3) at Amazon`, etc
        let pattern = """
        \\[
        (\\\\)? # Older specs looked like `[\\$199 at Walmart]`
        (?<price>\\$[0-9.]*)
        \\s.*at\\s
        (?<store>.*)
        \\]
        \\(
        (?<link>https://w{3}\\..*)
        \\)
        """

        let regexOptions: NSRegularExpression.Options = [.allowCommentsAndWhitespace]
        guard let regex = try? NSRegularExpression(pattern: pattern, options: regexOptions) else {
            return nil
        }
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

    // MARK: - Formatting

    private func formatPriceComparison(_ priceComparison: PriceComparison) -> String {
        // TODO: handle localization (including price conversion?)
        return "\(priceComparison.price) at \(priceComparison.store)"
    }

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

// MARK: - Themeable
extension FooterView: Themeable {
    public func apply(theme: AppTheme) {
        // accentColor
        self.backgroundColor = theme.accentColor
        buyButton.setTitleColor(theme.accentColor, for: .normal)

        // backgroundColor
        priceLabel.textColor = theme.backgroundColor
        priceComparisonLabel.textColor = theme.backgroundColor.withAlphaComponent(0.5)
        buyButton.backgroundColor = theme.backgroundColor

        // foreground
        //priceLabel.textColor = theme.foreground.textColor
    }

    func apply(theme: ColorTheme) {
        priceLabel.textColor = theme.label
        priceComparisonLabel.textColor = theme.secondaryLabel

        backgroundColor = theme.secondarySystemBackground

        buyButton.setTitleColor(theme.secondarySystemBackground, for: .normal)
        buyButton.setTitleColor(ColorCompatibility.systemBlue, for: .selected)
        buyButton.backgroundColor = theme.tint
    }
}
