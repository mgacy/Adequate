//
//  ColorTheme.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/16/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

struct ColorTheme {

    // MARK: - Tints

    //let tint: UIColor

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

    /// The color for text labels that contain tertiary content.
    //let tertiaryLabel: UIColor

    /// The color for text labels that contain quaternary content.
    //let quaternaryLabel: UIColor

    /// The color for placeholder text in controls or text views.
    //let placeholderText: UIColor

    /// The color for links.
    let link: UIColor

    /// The color for thin borders or divider lines that allows some underlying content to be visible.
    //let separator: UIColor

    /// The color for borders or divider lines that hides any underlying content.
    //let opaqueSeparator: UIColor
}

// MARK: - Initializers
extension ColorTheme {

    init(theme: ThemeType) {

        // Tints
        //let tint = UIColor(hexString: theme.accentColor)

        // Backgrounds
        let baseBackgroundColor = UIColor(hexString: theme.backgroundColor)
        self.systemBackground = baseBackgroundColor
        // TODO: is this the best way to achieve different shades?
        self.secondarySystemBackground = baseBackgroundColor.withAlphaComponent(0.75)
        //self.tertiarySystemBackground = baseBackgroundColor.withAlphaComponent(0.5)

        // Foreground
        self.label = theme.foreground.textColor
        // TODO: is this the best way to achieve different shades?
        self.secondaryLabel = theme.foreground.textColor.withAlphaComponent(0.75)
        //self.tertiaryLabel = theme.foreground.textColor.withAlphaComponent(0.5)
        //self.quaternaryLabel = theme.foreground.textColor.withAlphaComponent(0.25)

        // FIXME: choose appropriate color
        self.link = .blue
    }
}

// MARK: - Default
extension ColorTheme {
    static var system: ColorTheme {
        return ColorTheme(systemBackground: ColorCompatibility.systemBackground,
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
