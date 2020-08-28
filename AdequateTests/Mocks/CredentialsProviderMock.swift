//
//  CredentialsProviderMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 7/31/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import AWSMobileClient
import Promise
@testable import Adequate

public class CredentialsProviderMock: NSObject, CredentialsProvider {

    // MARK: Mock

    public var initializationResult: Result<UserState, AWSMobileClientError> = .success(.signedIn)

    public init(initialUserState: UserState = .unknown) {
        self.currentUserState = initialUserState
    }

    // MARK: CredentialsProvider

    public var currentUserState: UserState = .unknown

    public func initialize() -> Promise<UserState> {
        switch initializationResult {
        case .success(let userState):
            return Promise<UserState>(value: userState)
        case .failure(let error):
            return Promise<UserState>(error: error)
        }
    }
}

// MARK: - AWSCredentialsProvider
extension CredentialsProviderMock: AWSCredentialsProvider {

    public func credentials() -> AWSTask<AWSCredentials> {
        // FIXME: 
        let credentials: AWSCredentials = AWSCredentials(accessKey: "", secretKey: "", sessionKey: "", expiration: nil)
        return AWSTask<AWSCredentials>(result: credentials)
    }

    public func invalidateCachedTemporaryCredentials() {
        //
    }
}
