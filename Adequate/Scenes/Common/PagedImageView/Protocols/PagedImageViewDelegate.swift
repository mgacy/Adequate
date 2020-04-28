//
//  PagedImageViewDelegate.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/18/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Promise

protocol PagedImageViewDelegate: class {
    func displayFullScreenImage(dataSource: PagedImageViewDataSourceType, indexPath: IndexPath)
}
