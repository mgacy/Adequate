//
//  ViewAnimatedTransitioning.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/28/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

protocol ViewAnimatedTransitioning: AnyObject {
    var originFrame: CGRect { get }
    // TODO: replace with method to show / hide view?
    var originView: UIView { get }
    func makeTransitioningView() -> UIView?
}
