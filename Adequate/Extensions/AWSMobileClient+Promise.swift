//
//  AWSMobileClient+Promise.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSMobileClient
import Promise

extension AWSMobileClient {

    /// Initializes `AWSMobileClient` and determines the `UserState` for current user using cache.
    public func initialize() -> Promise<UserState> {
        return Promise<UserState> { fulfill, reject in
            self.initialize() { userState, error in
                if let error = error {
                    reject(error)
                } else if let userState = userState {
                    fulfill(userState)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }
        }
    }

}
