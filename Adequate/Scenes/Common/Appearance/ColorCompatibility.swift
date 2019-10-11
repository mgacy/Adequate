//
//  ColorCompatibility.swift
//  Adequate
//
//  https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
//  https://github.com/noahsark769/NGSystemColorComparison
//

import UIKit

// FIXME: for iOS12, this only covers (light?) mode
enum ColorCompatibility {

    // MARK: - Element Colors

    // MARK: Text Colors

    /// The color for text labels that contain primary content.
    static var label: UIColor {
        if #available(iOS 13, *) {
            return .label
        }
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    /// The color for text labels that contain secondary content.
    static var secondaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        }
        return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.6)
    }

    /// The color for text labels that contain tertiary content.
    static var tertiaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .tertiaryLabel
        }
        return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.3)
    }

    /// The color for text labels that contain quaternary content.
    static var quaternaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .quaternaryLabel
        }
        return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.18)
    }

    /// The color for placeholder text in controls or text views.
    static var placeholderText: UIColor {
        if #available(iOS 13, *) {
            return .placeholderText
        }
        return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.3)
    }

    /// The color for links.
    static var link: UIColor {
        if #available(iOS 13, *) {
            return .link
        }
        return UIColor(red: 0.03529411764705882, green: 0.5176470588235295, blue: 1.0, alpha: 1.0)
    }

    // MARK: Separator Colors

    /// The color for thin borders or divider lines that allows some underlying content to be visible.
    static var separator: UIColor {
        if #available(iOS 13, *) {
            return .separator
        }
        return UIColor(red: 0.32941176470588235, green: 0.32941176470588235, blue: 0.34509803921568627, alpha: 0.6)
    }

    /// The color for borders or divider lines that hides any underlying content.
    static var opaqueSeparator: UIColor {
        if #available(iOS 13, *) {
            return .opaqueSeparator
        }
        return UIColor(red: 0.2196078431372549, green: 0.2196078431372549, blue: 0.22745098039215686, alpha: 1.0)
    }

    // MARK: Fill Colors

    /// An overlay fill color for thin and small shapes.
    static var systemFill: UIColor {
        if #available(iOS 13, *) {
            return .systemFill
        }
        return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.36)
    }

    /// An overlay fill color for medium-size shapes.
    static var secondarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemFill
        }
        return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.32)
    }

    /// An overlay fill color for large shapes.
    static var tertiarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemFill
        }
        return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.24)
    }

    /// An overlay fill color for large areas that contain complex content.
    static var quaternarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .quaternarySystemFill
        }
        return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.18)
    }

    // MARK: Standard Content Background Colors

    /// The color for the main background of your interface.
    static var systemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        }
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }

    /// The color for content layered on top of the main background.
    static var secondarySystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemBackground
        }
        return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
    }

    /// The color for content layered on top of secondary backgrounds.
    static var tertiarySystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemBackground
        }
        return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
    }

    // MARK: Grouped Content Background Colors

    /// The color for the main background of your grouped interface.
    static var systemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemGroupedBackground
        }
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }

    /// The color for content layered on top of the main background of your grouped interface.
    static var secondarySystemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemGroupedBackground
        }
        return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
    }

    /// The color for content layered on top of secondary backgrounds of your grouped interface.
    static var tertiarySystemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemGroupedBackground
        }
        return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
    }

    // MARK: - Standard Colors

    // MARK: Adaptable Colors

    /// A blue color that automatically adapts to the current trait environment.
    static var systemBlue: UIColor {
        if #available(iOS 13, *) {
            return .systemBlue
        }
        // Color from HIG:
        // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color/
        //return UIColor(hexString: "#007AFF") // iOS 12
        return UIColor(red: 0.0, green: 0.478431373, blue: 1.0, alpha: 1.0) // iOS 13
    }

    /// A green color that automatically adapts to the current trait environment.
    static var systemGreen: UIColor {
        if #available(iOS 13, *) {
            return .systemGreen
        }
        return UIColor.green
    }

    /// An indigo color that automatically adapts to the current trait environment.
    static var systemIndigo: UIColor {
        if #available(iOS 13, *) {
            return .systemIndigo
        }
        return UIColor(red: 0.3686274509803922, green: 0.3607843137254902, blue: 0.9019607843137255, alpha: 1.0)
    }

    /// An orange color that automatically adapts to the current trait environment.
    static var systemOrange: UIColor {
        if #available(iOS 13, *) {
            return .systemOrange
        }
        return UIColor.orange
    }

    /// A pink color that automatically adapts to the current trait environment.
    static var systemPink: UIColor {
        if #available(iOS 13, *) {
            return .systemPink
        }
        // Value from HIG
        return UIColor(red: 1.0, green: 0.176470588, blue: 0.333333333, alpha: 1.0)
    }

    /// A purple color that automatically adapts to the current trait environment.
    static var systemPurple: UIColor {
        if #available(iOS 13, *) {
            return .systemPurple
        }
        return UIColor.purple
    }

    /// A red color that automatically adapts to the current trait environment.
    static var systemRed: UIColor {
        if #available(iOS 13, *) {
            return .systemRed
        }
        return UIColor.red
    }

    /// A teal color that automatically adapts to the current trait environment.
    static var systemTeal: UIColor {
        if #available(iOS 13, *) {
            return .systemTeal
        }
        // Value from HIG
        return UIColor(red: 0.352941176, green: 0.784313725, blue: 0.980392157, alpha: 1.0)
    }

    /// A yellow color that automatically adapts to the current trait environment.
    static var systemYellow: UIColor {
        if #available(iOS 13, *) {
            return .systemYellow
        }
        return UIColor.yellow
    }

    // MARK: Gray Colors

    /// The base gray color.
    static var systemGray: UIColor {
        if #available(iOS 13, *) {
            return .systemGray
        }
        return UIColor.gray
    }

    /// A second-level shade of grey.
    static var systemGray2: UIColor {
        if #available(iOS 13, *) {
            return .systemGray2
        }
        return UIColor(red: 0.38823529411764707, green: 0.38823529411764707, blue: 0.4, alpha: 1.0)
    }

    /// A third-level shade of grey.
    static var systemGray3: UIColor {
        if #available(iOS 13, *) {
            return .systemGray3
        }
        return UIColor(red: 0.2823529411764706, green: 0.2823529411764706, blue: 0.2901960784313726, alpha: 1.0)
    }

    /// A fourth-level shade of grey.
    static var systemGray4: UIColor {
        if #available(iOS 13, *) {
            return .systemGray4
        }
        return UIColor(red: 0.22745098039215686, green: 0.22745098039215686, blue: 0.23529411764705882, alpha: 1.0)
    }

    /// A fifth-level shade of grey.
    static var systemGray5: UIColor {
        if #available(iOS 13, *) {
            return .systemGray5
        }
        return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
    }

    /// A sixth-level shade of grey.
    static var systemGray6: UIColor {
        if #available(iOS 13, *) {
            return .systemGray6
        }
        return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
    }
}
