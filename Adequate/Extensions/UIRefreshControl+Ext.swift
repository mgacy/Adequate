//
//  UIRefreshControl+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public extension UIRefreshControl {
    /// Allow programmatic refresh
    /// https://stackoverflow.com/a/14719658/4472195
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - frame.size.height), animated: true)
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}
