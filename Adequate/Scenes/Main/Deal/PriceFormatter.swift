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
        //formatter.locale = .autoupdatingCurrent
        return formatter
    }()

    // MARK: - Interface

    func parsePriceData(from deal: Deal) throws -> PriceData {
        let priceText = (parsePriceRange >>> formatPriceRange)(deal)
        let priceComparison = try parsePriceComparison(from: deal.specifications)
            .flatMap { formatPriceComparison($0) }
        return (priceText: priceText, priceComparison: priceComparison)
    }

    // MARK: - Parsing

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

    // MARK: - Formatting

    private func formatPriceComparison(_ priceComparison: PriceComparison) -> String {
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
