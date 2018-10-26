//
//  PaddingLabel.swift
//  Adequate
//

import UIKit

// https://stackoverflow.com/a/32785683/4472195
class PaddingLabel: UILabel {

    let padding: UIEdgeInsets

    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    // For Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

    // For Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

}
