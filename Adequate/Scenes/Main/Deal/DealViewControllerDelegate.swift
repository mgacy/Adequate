//
//  DealViewControllerDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

protocol DealViewControllerDelegate: AnyObject, FullScreenImagePresenting {
    func showPurchase(for: Deal)
    func showForum(with: Topic)
    func showHistoryList()
    func showStory()
}
