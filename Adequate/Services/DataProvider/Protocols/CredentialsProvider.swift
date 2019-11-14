//
//  CredentialsProvider.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/12/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import AWSMobileClient
import Promise

protocol CredentialsProvider: AWSCredentialsProvider {

    var currentUserState: UserState { get }

    func initialize() -> Promise<UserState>
}

// MARK: AWSMobileClient + CredentialsProvider
extension AWSMobileClient: CredentialsProvider {}
