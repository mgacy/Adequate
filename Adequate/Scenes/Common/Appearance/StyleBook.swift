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
        //static let rounded = Style<UIButton> { $0.layer.cornerRadius = AppTheme.CornerRadius.extraSmall }

        static let base = Style<UIButton> {
            $0.contentEdgeInsets = UIEdgeInsets(horizontal: 8.0, vertical: 6.0)
            $0.layer.cornerRadius = AppTheme.CornerRadius.extraSmall
            $0.titleLabel?.adjustsFontForContentSizeCategory = true // ?
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // TODO: rename `regularFont`?
        static let regular = Style<UIButton> {
            $0.titleLabel?.font = FontBook.regularButton
        }

        static let bold = Style<UIButton> {
            $0.titleLabel?.font = FontBook.mediumButton
        }

        static let standardInsets = Style<UIButton> {
            $0.contentEdgeInsets = UIEdgeInsets(horizontal: 8.0, vertical: 6.0)
        }

        static let wideInsets = Style<UIButton> {
            $0.contentEdgeInsets = UIEdgeInsets(horizontal: 15.0, vertical: 5.0)
        }

        // MARK: Standard Button

        static let standard = Button.base <> Button.bold

        //static func standard(color: UIColor) -> Style<UIButton> {
        //    return .init {
        //        $0.backgroundColor =
        //        $0.setTitleColor(color, for: .normal)
        //    }
        //}

        // MARK: Secondary Button

        static let secondaryBase = Style<UIButton> {
            $0.titleLabel?.font = FontBook.regularButton
            $0.layer.borderWidth = 1.0
            $0.backgroundColor = .clear
        }

        static let secondary = Button.base <> Button.secondaryBase <> Button.standardInsets

        static let secondaryWide = Style<UIButton> {
            $0.contentEdgeInsets = UIEdgeInsets(horizontal: 15.0, vertical: 5.0)
            $0.layer.cornerRadius = AppTheme.CornerRadius.extraSmall
            $0.titleLabel?.adjustsFontForContentSizeCategory = true // ?
            $0.translatesAutoresizingMaskIntoConstraints = false
        } <> secondaryBase

        static func secondary(color: UIColor) -> Style<UIButton> {
            return .init {
                $0.layer.borderColor = color.cgColor
                $0.setTitleColor(color, for: .normal)
            } <> base <> secondaryBase
        }

        // FooterViewController.buyButton
        static let x = Style<UIButton> {
            // TODO: should we make a func and pass titleColor or ColorTheme?
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
            $0.font = FontBook.compactFooter // ?
            $0.textColor = ColorCompatibility.label
        } <> base

        // FooterViewController.priceComparisonLabel
        static let secondary = Style<UILabel> {
            $0.font = UIFont.preferredFont(forTextStyle: .caption2)
            $0.textColor = ColorCompatibility.secondaryLabel
        } <> base

        // UITableView

        // TODO: make name more generic?
        static let cellTitle = Style<UILabel> {
            $0.numberOfLines = 2
            $0.font = UIFont.preferredFont(forTextStyle: .headline)
        } <> base
    }

    // MARK: - UINavigationItem
    enum NavigationItem {

        static let opaque = Style<UINavigationItem> {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            $0.standardAppearance = appearance
            $0.scrollEdgeAppearance = appearance
            $0.compactAppearance = appearance
        }

        static let translucent = Style<UINavigationItem> {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            $0.standardAppearance = appearance
            $0.scrollEdgeAppearance = appearance
            $0.compactAppearance = appearance
        }

        static let transparent = Style<UINavigationItem> {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            $0.standardAppearance = appearance
            $0.scrollEdgeAppearance = appearance
            $0.compactAppearance = appearance
        }
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
