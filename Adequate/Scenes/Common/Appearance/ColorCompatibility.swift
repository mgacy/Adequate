//
//  ColorCompatibility.swift
//  Adequate
//
//  https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
//  https://github.com/noahsark769/NGSystemColorComparison
//

import UIKit

enum ColorCompatibility {

    // MARK: - Element Colors

    // MARK: Text Colors

    /// The color for text labels that contain primary content.
    static var label: UIColor {
        if #available(iOS 13, *) {
            return .label
        }
        // Dark
        //return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Light
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }

    /// The color for text labels that contain secondary content.
    static var secondaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        }
        // Dark
        //return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.6)
        // Light
        return UIColor(r: 60, g: 60, b: 67, a: 0.6)
    }

    /// The color for text labels that contain tertiary content.
    static var tertiaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .tertiaryLabel
        }
        // Dark
        //return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.3)
        // Light
        return UIColor(r: 60, g: 60, b: 67, a: 0.3)
    }

    /// The color for text labels that contain quaternary content.
    static var quaternaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .quaternaryLabel
        }
        // Dark
        //return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.18)
        // Light
        return UIColor(r: 60, g: 60, b: 67, a: 0.18)
    }

    /// The color for placeholder text in controls or text views.
    static var placeholderText: UIColor {
        if #available(iOS 13, *) {
            return .placeholderText
        }
        // Dark
        //return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.3)
        // Light
        return UIColor(r: 60, g: 60, b: 67, a: 0.3)
    }

    /// The color for links.
    static var link: UIColor {
        if #available(iOS 13, *) {
            return .link
        }
        // Dark
        //return UIColor(red: 0.03529411764705882, green: 0.5176470588235295, blue: 1.0, alpha: 1.0)
        // Light
        return UIColor(r: 0, g: 122, b: 255, a: 1.0)
    }

    // MARK: Separator Colors

    /// The color for thin borders or divider lines that allows some underlying content to be visible.
    static var separator: UIColor {
        if #available(iOS 13, *) {
            return .separator
        }
        // Dark
        //return UIColor(red: 0.32941176470588235, green: 0.32941176470588235, blue: 0.34509803921568627, alpha: 0.6)
        // Light
        return UIColor(r: 60, g: 60, b: 67, a: 0.29)
    }

    /// The color for borders or divider lines that hides any underlying content.
    static var opaqueSeparator: UIColor {
        if #available(iOS 13, *) {
            return .opaqueSeparator
        }
        // Dark
        //return UIColor(red: 0.2196078431372549, green: 0.2196078431372549, blue: 0.22745098039215686, alpha: 1.0)
        // Light
        return UIColor(r: 198, g: 198, b: 200, a: 1.0)
    }

    // MARK: Fill Colors

    /// An overlay fill color for thin and small shapes.
    static var systemFill: UIColor {
        if #available(iOS 13, *) {
            return .systemFill
        }
        // Dark
        //return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.36)
        // Light
        return UIColor(r: 120, g: 120, b: 128, a: 0.2)
    }

    /// An overlay fill color for medium-size shapes.
    static var secondarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemFill
        }
        // Dark
        //return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.32)
        // Light
        return UIColor(r: 120, g: 120, b: 128, a: 0.16)
    }

    /// An overlay fill color for large shapes.
    static var tertiarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemFill
        }
        // Dark
        //return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.24)
        // Light
        return UIColor(r: 118, g: 118, b: 128, a: 0.12)
    }

    /// An overlay fill color for large areas that contain complex content.
    static var quaternarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .quaternarySystemFill
        }
        // Dark
        //return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.18)
        // Light
        return UIColor(r: 116, g: 116, b: 128, a: 0.08)
    }

    // MARK: Standard Content Background Colors

    /// The color for the main background of your interface.
    static var systemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        }
        // Dark
        //return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        // Light
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    /// The color for content layered on top of the main background.
    static var secondarySystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemBackground
        }
        // Dark
        //return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
        // Light
        return UIColor(r: 242, g: 242, b: 247, a: 1.0)
    }

    /// The color for content layered on top of secondary backgrounds.
    static var tertiarySystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemBackground
        }
        // Dark
        //return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
        // Light
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    // MARK: Grouped Content Background Colors

    /// The color for the main background of your grouped interface.
    static var systemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemGroupedBackground
        }
        // Dark
        //return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        // Light
        return UIColor(r: 242, g: 242, b: 247, a: 1.0)
    }

    /// The color for content layered on top of the main background of your grouped interface.
    static var secondarySystemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemGroupedBackground
        }
        // Dark
        //return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
        // Light
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    /// The color for content layered on top of secondary backgrounds of your grouped interface.
    static var tertiarySystemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemGroupedBackground
        }
        // Dark
        //return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
        // Light
        return UIColor(r: 242, g: 242, b: 247, a: 1.0)
    }

    // MARK: - Standard Colors

    // MARK: Adaptable Colors

    /// A blue color that automatically adapts to the current trait environment.
    static var systemBlue: UIColor {
        if #available(iOS 13, *) {
            return .systemBlue
        }
        // Dark
        //return UIColor(r: 10, g: 132, b: 255, a: 1.0)
        // Light
        return UIColor(r: 0, g: 122, b: 255, a: 1.0)
    }

    /// A green color that automatically adapts to the current trait environment.
    static var systemGreen: UIColor {
        if #available(iOS 13, *) {
            return .systemGreen
        }
        // Dark
        //return UIColor(r: 48, g: 209, b: 88, a: 1.0)
        // Light
        return UIColor(r: 52, g: 199, b: 89, a: 1.0)
    }

    /// An indigo color that automatically adapts to the current trait environment.
    static var systemIndigo: UIColor {
        if #available(iOS 13, *) {
            return .systemIndigo
        }
        // Dark
        //return UIColor(r: 94, g: 92, b: 230, a: 1.0)
        // Light
        return UIColor(r: 88, g: 86, b: 214, a: 1.0)
    }

    /// An orange color that automatically adapts to the current trait environment.
    static var systemOrange: UIColor {
        if #available(iOS 13, *) {
            return .systemOrange
        }
        // Dark
        //return UIColor(r: 255, g: 159, b: 10, a: 1.0)
        // Light
        return UIColor(r: 255, g: 149, b: 0, a: 1.0)
    }

    /// A pink color that automatically adapts to the current trait environment.
    static var systemPink: UIColor {
        if #available(iOS 13, *) {
            return .systemPink
        }
        // Dark
        //return UIColor(r: 255, g: 55, b: 95, a: 1.0)
        // Light
        return UIColor(r: 255, g: 45, b: 85, a: 1.0)
    }

    /// A purple color that automatically adapts to the current trait environment.
    static var systemPurple: UIColor {
        if #available(iOS 13, *) {
            return .systemPurple
        }
        // Dark
        //return UIColor(r: 191, g: 90, b: 242, a: 1.0)
        // Light
        return UIColor(r: 175, g: 82, b: 222, a: 1.0)
    }

    /// A red color that automatically adapts to the current trait environment.
    static var systemRed: UIColor {
        if #available(iOS 13, *) {
            return .systemRed
        }
        // Dark
        //return UIColor(r: 255, g: 69, b: 58, a: 1.0)
        // Light
        return UIColor(r: 255, g: 59, b: 48, a: 1.0)
    }

    /// A teal color that automatically adapts to the current trait environment.
    static var systemTeal: UIColor {
        if #available(iOS 13, *) {
            return .systemTeal
        }
        // Dark
        //return UIColor(r: 100, g: 210, b: 255, a: 1.0)
        // Light
        return UIColor(r: 90, g: 200, b: 250, a: 1.0)
    }

    /// A yellow color that automatically adapts to the current trait environment.
    static var systemYellow: UIColor {
        if #available(iOS 13, *) {
            return .systemYellow
        }
        // Dark
        //return UIColor(r: 255, g: 214, b: 10, a: 1.0)
        // Light
        return UIColor(r: 255, g: 204, b: 0, a: 1.0)
    }

    // MARK: Gray Colors

    /// The base gray color.
    static var systemGray: UIColor {
        if #available(iOS 13, *) {
            return .systemGray
        }
        // Dark & Light
        return UIColor(r: 142, g: 142, b: 147, a: 1.0)
    }

    /// A second-level shade of grey.
    static var systemGray2: UIColor {
        if #available(iOS 13, *) {
            return .systemGray2
        }
        // Dark
        //return UIColor(red: 0.38823529411764707, green: 0.38823529411764707, blue: 0.4, alpha: 1.0)
        // Light
        return UIColor(r: 174, g: 174, b: 178, a: 1.0)
    }

    /// A third-level shade of grey.
    static var systemGray3: UIColor {
        if #available(iOS 13, *) {
            return .systemGray3
        }
        // Dark
        //return UIColor(red: 0.2823529411764706, green: 0.2823529411764706, blue: 0.2901960784313726, alpha: 1.0)
        // Light
        return UIColor(r: 199, g: 199, b: 204, a: 1.0)
    }

    /// A fourth-level shade of grey.
    static var systemGray4: UIColor {
        if #available(iOS 13, *) {
            return .systemGray4
        }
        // Dark
        //return UIColor(red: 0.22745098039215686, green: 0.22745098039215686, blue: 0.23529411764705882, alpha: 1.0)
        // Light
        return UIColor(r: 209, g: 209, b: 214, a: 1.0)
    }

    /// A fifth-level shade of grey.
    static var systemGray5: UIColor {
        if #available(iOS 13, *) {
            return .systemGray5
        }
        // Dark
        //return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
        // Light
        return UIColor(r: 299, g: 229, b: 234, a: 1.0)
    }

    /// A sixth-level shade of grey.
    static var systemGray6: UIColor {
        if #available(iOS 13, *) {
            return .systemGray6
        }
        // Dark
        //return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
        // Light
        return UIColor(r: 242, g: 242, b: 247, a: 1.0)
    }
}
