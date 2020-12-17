//
//  DealViewControllerDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

protocol DealViewControllerDelegate: AnyObject, FullScreenImagePresenting {
    func showPurchase(for: Deal)
    func showForum(with: Topic)
    func showShareSheet(activityItems: [Any], from sourceView: UIView)
    func showShareSheet(activityItems: [Any], from barButtonItem: UIBarButtonItem)
    func showHistoryList()
    func showStory()
}
