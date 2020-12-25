//
//  StyleBook.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/14/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

enum StyleBook {

    // MARK: - MGButton
    enum Button {

        /// - layer.cornerRadius = AppTheme.CornerRadius.extraSmall
        /// - adjustsFontForContentSizeCategory = true
        /// - translatesAutoresizingMaskIntoConstraints = false
        static let base = Style<AnimatableButton> {
            $0.layer.cornerRadius = AppTheme.CornerRadius.extraSmall
            $0.titleLabel?.adjustsFontForContentSizeCategory = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        static let regularFont = Style<AnimatableButton> {
            $0.titleLabel?.font = FontBook.regularButton
        }

        static let mediumFont = Style<AnimatableButton> {
            $0.titleLabel?.font = FontBook.mediumButton
        }

        /// - horizontal edge insets = 8.0
        /// - vertical edge insets = 6.0
        static let standardInsets = Style<AnimatableButton> {
            $0.contentEdgeInsets = UIEdgeInsets(horizontal: 8.0, vertical: 6.0)
        }

        /// - horizontal edge insets = 15.0
        /// - vertical edge insets = 5.0
        static let wideInsets = Style<AnimatableButton> {
            $0.contentEdgeInsets = UIEdgeInsets(horizontal: 15.0, vertical: 5.0)
        }

        // MARK: Standard Button

        static let standard: Style<AnimatableButton> = base <> mediumFont <> standardInsets

        // MARK: Secondary Button

        static let secondaryBase = Style<AnimatableButton> {
            $0.titleLabel?.font = FontBook.regularButton
            $0.layer.borderWidth = 1.0
            $0.backgroundColor = .clear
        }

        static let secondary: Style<AnimatableButton> = base <> secondaryBase <> standardInsets

        static let secondaryWide: Style<AnimatableButton> = base <> secondaryBase <> wideInsets

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
            $0.textColor = .label
        } <> base

        // FooterViewController.priceComparisonLabel
        static let secondary = Style<UILabel> {
            $0.font = UIFont.preferredFont(forTextStyle: .caption2)
            $0.textColor = .secondaryLabel
        } <> base

        // UITableView

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

        /// - translatesAutoresizingMaskIntoConstraints = false
        static let autolayout = Style<UIView> {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        static func rounded(radius: CGFloat) -> Style<UIView> {
            .init { $0.layer.cornerRadius = radius }
        }
    }
}

// MARK: Button + ColorTheme
extension StyleBook.Button {

    static func themed(theme: ColorTheme) -> Style<AnimatableButton> {
        return .init {
            $0.apply(theme: theme)
        }
    }

    static func standard(theme: ColorTheme) -> Style<AnimatableButton> {
        return .init {
            $0.backgroundColor = theme.tint
            $0.setTitleColor(theme.systemBackground, for: .normal)
        } <> themed(theme: theme)
    }

    // FooterViewController.buyButton
    static func standardElevated(theme: ColorTheme) -> Style<AnimatableButton> {
        return .init {
            $0.backgroundColor = theme.tint
            $0.setTitleColor(theme.secondarySystemBackground, for: .normal)
        } <> themed(theme: theme)
    }

    static func secondary(theme: ColorTheme) -> Style<AnimatableButton> {
        return secondary(color: theme.tint) <> themed(theme: theme)
    }

    static func secondarySupplementary(theme: ColorTheme) -> Style<AnimatableButton> {
        return secondary(color: theme.secondaryLabel) <> themed(theme: theme)
    }

    // MARK: - Private Helpers

    private static func secondary(color: UIColor) -> Style<AnimatableButton> {
        return .init {
            $0.layer.borderColor = color.cgColor
            $0.setTitleColor(color, for: .normal)
            //$0.setTitleColor(?, for: .disabled)
        }
    }
}
