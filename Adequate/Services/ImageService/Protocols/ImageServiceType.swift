//
//  ImageServiceType.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

public protocol ImageServiceType {
    func fetchImage(for url: URL) -> Promise<UIImage>
    func fetchedImage(for url: URL, tryingSecondary: Bool) -> UIImage?
    //func cancelFetch(_ url: URL)
    func clearCache()
}
