//
//  HistoryDetailViewControllerDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/18/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

protocol HistoryDetailViewControllerDelegate: VoidDismissalDelegate, FullScreenImagePresenting {
    func showForum(with: TopicType)
}
