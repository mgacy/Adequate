//
//  SplitLayout.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

enum SplitLayout {
    case compact
    case regularLandscape
    case regularPortrait
    //case regular(ScreenOrientation)

    init?(traitCollection: UITraitCollection, frame: CGRect) {
        switch traitCollection.horizontalSizeClass {
        case .compact:
            self = .compact
        case .regular:
            if frame.width > frame.height {
                self = .regularLandscape
                //self = .regular(.landscape)
            } else {
                self = .regularPortrait
                //self = .regular(.protrait)
            }
        default:
            return nil
        }
    }
}

//enum ScreenOrientation {
//    case landscape
//    case protrait
//}

// MARK: - UIViewController + SplitLayout
extension UIViewController {

    var layout: SplitLayout? {
        return SplitLayout(traitCollection: traitCollection,
                           frame: view.frame)
    }
}
