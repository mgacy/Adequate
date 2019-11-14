//
//  UIFont+Traits.swift
//  Down
//
//  Created by John Nguyen on 22.06.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

import UIKit

extension UIFont {

    var isBold: Bool {
        return contains(.traitBold)
    }

    var isItalic: Bool {
        return contains(.traitItalic)
    }

    var isMonospace: Bool {
        return contains(.traitMonoSpace)
    }

    var bold: UIFont {
        return with(.traitBold) ?? self
    }

    var italic: UIFont {
        return with(.traitItalic) ?? self
    }

    var monospace: UIFont {
        return with(.traitMonoSpace) ?? self
    }

    private func with(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont? {
        guard !contains(trait) else { return self }

        var traits = fontDescriptor.symbolicTraits
        traits.insert(trait)

        guard let newDescriptor = fontDescriptor.withSymbolicTraits(traits) else { return nil }

        return UIFont(descriptor: newDescriptor, size: pointSize)
    }

    private func contains(_ trait: UIFontDescriptor.SymbolicTraits) -> Bool {
        return fontDescriptor.symbolicTraits.contains(trait)
    }
}
