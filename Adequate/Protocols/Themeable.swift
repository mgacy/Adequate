//
//  Themeable.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

protocol Themeable {
    func apply(theme: AppTheme)
    func apply(theme: ColorTheme)
}
