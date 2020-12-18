//
//  ColorTheme.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/16/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

struct ColorTheme: Equatable {

    // MARK: - Tints

    /// The color for interactive elements, illustrations, and highlights.
    let tint: UIColor

    let secondaryTint: UIColor

    let tertiaryTint: UIColor

    // MARK: - Backgrounds

    /// The color for the main background of your interface.
    let systemBackground: UIColor

    /// The color for content layered on top of the main background.
    let secondarySystemBackground: UIColor

    /// The color for content layered on top of secondary backgrounds.
    //let tertiarySystemBackground: UIColor

    // MARK: - Foreground

    /// The color for text labels that contain primary content.
    let label: UIColor

    /// The color for text labels that contain secondary content.
    let secondaryLabel: UIColor

    // The color for text labels that contain tertiary content.
    //let tertiaryLabel: UIColor

    // The color for text labels that contain quaternary content.
    //let quaternaryLabel: UIColor

    // The color for placeholder text in controls or text views.
    //let placeholderText: UIColor

    /// The color for links.
    let link: UIColor

    // The color for thin borders or divider lines that allows some underlying content to be visible.
    //let separator: UIColor

    // The color for borders or divider lines that hides any underlying content.
    //let opaqueSeparator: UIColor

    //let foreground: ThemeForeground?
}

// MARK: - Initializers
extension ColorTheme {

    init(theme: Theme) {

        // Tints
        self.tint = theme.accentColor
        self.secondaryTint = theme.accentColor.withAlphaComponent(0.6)
        self.tertiaryTint = theme.accentColor.withAlphaComponent(0.3)

        // Backgrounds
        self.systemBackground = theme.backgroundColor
        self.secondarySystemBackground = theme.backgroundColor.withAlphaComponent(0.75)
        //self.tertiarySystemBackground = theme.backgroundColor.withAlphaComponent(0.5)

        // Foreground
        self.label = theme.foreground.textColor
        self.secondaryLabel = theme.foreground.textColor.withAlphaComponent(0.6)
        //self.tertiaryLabel = theme.foreground.textColor.withAlphaComponent(0.3)
        //self.quaternaryLabel = theme.foreground.textColor.withAlphaComponent(0.18)

        self.link = theme.accentColor
    }

    init(theme: ThemeType) {

        // Tints
        let accentColor = UIColor(hexString: theme.accentColor)
        self.tint = accentColor
        self.secondaryTint = accentColor.withAlphaComponent(0.6)
        self.tertiaryTint = accentColor.withAlphaComponent(0.3)

        // Backgrounds
        let baseBackgroundColor = UIColor(hexString: theme.backgroundColor)
        self.systemBackground = baseBackgroundColor
        self.secondarySystemBackground = baseBackgroundColor.withAlphaComponent(0.75)
        //self.tertiarySystemBackground = baseBackgroundColor.withAlphaComponent(0.5)

        // Foreground
        self.label = theme.foreground.textColor
        self.secondaryLabel = theme.foreground.textColor.withAlphaComponent(0.6)
        //self.tertiaryLabel = theme.foreground.textColor.withAlphaComponent(0.3)
        //self.quaternaryLabel = theme.foreground.textColor.withAlphaComponent(0.18)

        self.link = accentColor
    }
}

// MARK: - Default
extension ColorTheme {
    static var system: ColorTheme {
        return ColorTheme(tint: ColorCompatibility.label,
                          secondaryTint: ColorCompatibility.secondaryLabel,
                          tertiaryTint: ColorCompatibility.tertiaryLabel,
                          systemBackground: ColorCompatibility.systemBackground,
                          secondarySystemBackground: ColorCompatibility.secondarySystemBackground,
                          label: ColorCompatibility.label,
                          secondaryLabel: ColorCompatibility.secondaryLabel,
                          //tertiaryLabel: ColorCompatibility.tertiaryLabel,
                          //quaternaryLabel: ColorCompatibility.quaternaryLabel,
                          //placeholderText: ColorCompatibility.placeholderText,
                          link: ColorCompatibility.link
                          //separator: ColorCompatibility.separator,
                          //opaqueSeparator: ColorCompatibility.opaqueSeparator
                          )
    }
}
