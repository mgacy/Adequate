//
//  FileCache+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/31/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import class UIKit.UIImage
import MGNetworking

// MARK: - FileCache+ImageCaching
extension FileCache: ImageCaching where T == UIImage {}

// MARK: - AppGroup+currentDeal
extension AppGroup {
    static var currentDeal: AppGroup {
        return AppGroup(appGroupID: "group.mgacy.com.currentDeal",
                        pathComponent: Constants.cacheDirectory)
    }

    // TODO: make `struct Config` and initialize?
    enum Constants {
        static var cacheDirectory: String = "Library/Caches"
    }
}
