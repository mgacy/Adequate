//
//  UILabel+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/3/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

extension UILabel {
    func setStrikethrough(text: String, color: UIColor? = nil) {
        var attributes: [NSAttributedString.Key : Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        if let strikethroughColor = color {
            attributes[.strikethroughColor] = strikethroughColor
        }
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedText
    }
}
