//
//  StyleBook.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/14/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

enum StyleBook {

    // MARK: - UIButton
    enum Button {

        //static let dynamic = Style<UIButton> { $0.titleLabel?.adjustsFontForContentSizeCategory = true }
        //static let autolayout = Style<UIButton> { $0.translatesAutoresizingMaskIntoConstraints = false }
        //static let rounded = Style<UIButton> { $0.layer.cornerRadius = 5.0 }

        static let base = Style<UIButton> {
            $0.contentEdgeInsets = UIEdgeInsets(horizontal: 8.0, vertical: 6.0)
            $0.layer.cornerRadius = 5.0
            $0.titleLabel?.adjustsFontForContentSizeCategory = true // ?
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        static let bold = Style<UIButton> {
            $0.titleLabel?.font = FontBook.boldButton
        }
        /*
        static let secondary = Style<UIButton> {
            // TODO: what about font?
            //$0.titleLabel?.font = FontBook.boldButton
            $0.layer.borderWidth = 1.0
            $0.backgroundColor = .clear
            $0.layer.borderColor = $0.tintColor.cgColor
            $0.setTitleColor($0.tintColor, for: .normal)
        } <> base
        */
        static func secondary(color: UIColor) -> Style<UIButton> {
            return .init {
                // TODO: what about font?
                //$0.titleLabel?.font = FontBook.boldButton
                $0.backgroundColor = .clear
                $0.layer.borderWidth = 1.0
                $0.layer.borderColor = color.cgColor
                $0.setTitleColor(color, for: .normal)
            } <> base
        }

        static let standard = Style<UIButton> {
            $0.titleLabel?.font = FontBook.boldButton
            //$0.backgroundColor =
        } <> base

        // FooterViewController.buyButton
        static let x = Style<UIButton> {
            // TODO: should we make a func and pass titleColor?
            $0.setTitleColor($0.tintColor, for: .normal)
            $0.backgroundColor = .systemBackground
        }
    }

    // MARK: - UILabel
    enum Label {

        /// - adjustsFontForContentSizeCategory = true
        /// - translatesAutoresizingMaskIntoConstraints = false
        static let base = Style<UILabel> {
            $0.adjustsFontForContentSizeCategory = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        static let centered = Style<UILabel> {
            $0.textAlignment = .center
        }

        static let title = Style<UILabel> {
            $0.numberOfLines = 0
            $0.font = FontBook.mainTitle
        } <> base

        // FooterViewController.priceLabel
        static let primary = Style<UILabel> {
            $0.textColor = ColorCompatibility.label
            $0.font = FontBook.compactFooter // ?
        } <> base

        // FooterViewController.priceComparisonLabel
        static let secondary = Style<UILabel> {
            $0.textColor = ColorCompatibility.secondaryLabel
            $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        } <> base

        // UITableView

        // TODO: make name more generic?
        static let cellTitle = Style<UILabel> {
            $0.numberOfLines = 2
            $0.font = UIFont.preferredFont(forTextStyle: .headline)
        } <> base
    }

    // MARK: - UIStackView
    enum StackView {

        static func horizontal(spacing: CGFloat? = nil) -> Style<UIStackView> {
            return .init {
                $0.axis = .horizontal
                $0.alignment = .center
                $0.distribution = .fillEqually
                if let spacing = spacing {
                    $0.spacing = spacing
                }
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        }

        static func vertical(spacing: CGFloat? = nil) -> Style<UIStackView> {
            return .init {
                $0.axis = .vertical
                $0.alignment = .leading
                $0.distribution = .fill
                if let spacing = spacing {
                    $0.spacing = spacing
                }
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }

    // MARK: - UITextView
    enum TextView {

        /// - adjustsFontForContentSizeCategory = true
        /// - translatesAutoresizingMaskIntoConstraints = false
        static let base = Style<UITextView> {
            $0.adjustsFontForContentSizeCategory = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    // MARK: - UIView
    enum View {

        static let autolayout = Style<UIView> {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        static func rounded(radius: CGFloat) -> Style<UIView> {
            .init { $0.layer.cornerRadius = radius }
        }
    }
}
