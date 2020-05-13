//
//  PagedImageViewDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Promise

protocol PagedImageViewDelegate: AnyObject {
    func displayFullScreenImage(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath)
}
