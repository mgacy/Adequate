//
//  URL+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

extension URL {

    public func secure() -> URL? {
        guard let scheme = self.scheme else {
            return nil
        }
        switch scheme {
        case "https":
            return self
        case "http":
            guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
                return nil
            }
            components.scheme = "https"
            return components.url
        default:
            return nil
        }
    }

}
