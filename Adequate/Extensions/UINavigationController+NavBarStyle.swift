//
//  File.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/3/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public enum NavBarStyle {
    case normal
    case hiddenBar
    case hiddenSeparator
    case transparent
}

extension UINavigationController {
    func appleStyle(_ navBarStyle: NavBarStyle) {
        switch navBarStyle {
        case .hiddenBar:
            isNavigationBarHidden = true
        case .hiddenSeparator:
            isNavigationBarHidden = false
            navigationBar.setValue(true, forKey: "hidesShadow")
            navigationBar.isTranslucent = false
        case .normal:
           isNavigationBarHidden = false
           navigationBar.setValue(false, forKey: "hidesShadow")
           navigationBar.isTranslucent = true
        case .transparent:
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
    }
}
