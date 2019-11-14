//
//  UIColor.swift
//  previously Color+HexAndCSSColorNames.swift
//
//  Created by Norman Basham on 12/8/15.
//  Copyright © 2017 Black Labs. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  From:
//  https://gist.github.com/nbasham/3b2de0566d5f716894fc
//
//  See:
//  https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
//  https://stackoverflow.com/a/27203691
//

import UIKit

// MARK: - Hex Initializer
public extension UIColor {

    /**
     Creates an immuatble UIColor instance specified by a hex string or nil.
     - parameter hexString: A case insensitive String? representing a hex value e.g.
     - **"abc"**
     - **"abc7"**
     - **"#abc7"**
     - **"00FFFF"**
     - **"#00FFFF"**
     - **"00FFFF77"**
     - **nil** [UIColor clearColor]
     - **empty string** [UIColor clearColor]
     */
    convenience init(hexString: String?) {
        let normalizedHexString: String = UIColor.normalize(hexString)
        var c: CUnsignedInt = 0
        Scanner(string: normalizedHexString).scanHexInt32(&c)
        self.init(red:UIColorMasks.redValue(c), green:UIColorMasks.greenValue(c), blue:UIColorMasks.blueValue(c), alpha:UIColorMasks.alphaValue(c))
    }

    /**
     Returns a hex equivalent of this UIColor.
     - Parameter includeAlpha:   Optional parameter to include the alpha hex.
     color.hexDescription() -> "ff0000"
     color.hexDescription(true) -> "ff0000aa"
     - Returns: A new string with `String` with the color's hexidecimal value.
     */
    func hexDescription(_ includeAlpha: Bool = false) -> String {
        guard self.cgColor.numberOfComponents == 4 else {
            return "Color not RGB."
        }
        let a = self.cgColor.components!.map { Int($0 * CGFloat(255)) }
        let color = String.init(format: "%02x%02x%02x", a[0], a[1], a[2])
        if includeAlpha {
            let alpha = String.init(format: "%02x", a[3])
            return "\(color)\(alpha)"
        }
        return color
    }

    fileprivate enum UIColorMasks: CUnsignedInt {
        case redMask    = 0xff000000
        case greenMask  = 0x00ff0000
        case blueMask   = 0x0000ff00
        case alphaMask  = 0x000000ff

        static func redValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & redMask.rawValue) >> 24) / 255.0
        }

        static func greenValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & greenMask.rawValue) >> 16) / 255.0
        }

        static func blueValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & blueMask.rawValue) >> 8) / 255.0
        }

        static func alphaValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat(value & alphaMask.rawValue) / 255.0
        }
    }

    fileprivate static func normalize(_ hex: String?) -> String {
        guard var hexString = hex else {
            return "00000000"
        }
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count == 3 || hexString.count == 4 {
            hexString = hexString.map { "\($0)\($0)" } .joined()
        }
        let hasAlpha = hexString.count > 7
        if !hasAlpha {
            hexString += "ff"
        }
        return hexString
    }

}

// MARK - RGBA Initializer
extension UIColor {

    /// Creates a color object using the specified opacity and CSS RGB values.
    /// - Parameter r: The red value of the color object. Values below 0 are interpreted as 0 and values above 255 are interpreted as 255.
    /// - Parameter g: The green value of the color object. Values below 0 are interpreted as 0 and values above 255 are interpreted as 255.
    /// - Parameter b: The blue value of the color object. Values below 0 are interpreted as 0 and values above 255 are interpreted as 255.
    /// - Parameter a: The opacity value of the color object, specified as a value from 0.0 to 1.0. Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
    convenience init(r red: Int, g green: Int, b blue: Int, a alpha: CGFloat) {
        self.init(red: UIColor.clampingPercentage(red),
                  green: UIColor.clampingPercentage(green),
                  blue: UIColor.clampingPercentage(blue),
                  alpha: alpha)
    }

    fileprivate static func clampingPercentage(_ value: Int) -> CGFloat {
        if value <= 0 {
            return 0.0
        } else if value >= 255 {
            return 1.0
        } else {
            return CGFloat(value) / 255.0
        }
    }
}

// MARK: - HSB Manipulation
extension UIColor {

    // https://stackoverflow.com/a/51865114/4472195
    public func adjust(hueBy hue: CGFloat = 0, saturationBy saturation: CGFloat = 0, brightnessBy brightness: CGFloat = 0) -> UIColor {
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue + hue,
                       saturation: currentSaturation + saturation,
                       brightness: currentBrigthness + brightness,
                       alpha: currentAlpha)
        } else {
            return self
        }
    }
}
