//
//  ImageCaching.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

public protocol ImageCaching {
    func insert(_: UIImage, for: URL)
    func value(for: URL) -> UIImage?
    func removeValue(for: URL)
    func removeAll()
}
