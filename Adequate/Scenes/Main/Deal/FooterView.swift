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

    // MARK: - Appearance

    private let horizontalInset: CGFloat = 16.0

    // MARK: - Subviews

    private var bottomAnchorConstraint: NSLayoutConstraint!

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceComparisonLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(red:0.28, green:0.25, blue:0.19, alpha:1.00)
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
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
        button.setTitle("Buy", for: .normal)
        button.setTitle("Sold Out", for: .disabled)
        button.setTitleColor(button.tintColor, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
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

    // MARK: - Update View

    public func update(withDeal deal: Deal) {
        buyButton.isHidden = false
        guard deal.soldOutAt == nil else {
            buyButton.isEnabled = false
            /// TODO: hide or change color?
            priceLabel.isHidden = true
            priceComparisonLabel.isHidden = true
            return
        }
        buyButton.isEnabled = true

        // Price Comparison
        if let priceComparison = parsePriceComparison(from: deal.specifications) {
            /// TODO: handle localization (including price conversion?)
            priceComparisonLabel.text = "\(priceComparison.price) at \(priceComparison.store)"
            priceComparisonLabel.isHidden = false
        } else {
            print("ERROR : unable to parse price comparison")
            priceComparisonLabel.isHidden = true
        }

        // Price
        let priceText: String
        switch deal.items.count {
        case 0:
            priceText = "ERROR: missing price"
        case 1:
            priceText = "$\(deal.items[0].price)"
        default:
            let prices = deal.items.map { $0.price }
            if let minPrice = prices.min(), let maxPrice = prices.max() {
                /// TODO: handle case where minPrice == maxPrice
                priceText = minPrice == maxPrice ? "$\(minPrice)" : "$\(minPrice) - $\(maxPrice)"
            } else {
                priceText = "ERROR"
            }
        }
        priceLabel.text = priceText
        priceLabel.isHidden = false
    }

    // MARK: Helpers

    private func parsePriceComparison(from text: String) -> PriceComparison? {
        /// TODO: relocate pattern to PriceComparisonParser object
        let pattern = "\\[\\\\(?<price>\\$[0-9.]*)\\s.*at\\s(?<store>.*)\\]\\((?<link>https://w{3}\\..*)\\)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        /// TODO: use .flatMap or .map?
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
}
