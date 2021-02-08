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

    public var initializationResult: Result<UserState, AWSMobileClientError>

    var initializationPromise: Promise<UserState>!

    public init(
        initialUserState: UserState = .unknown,
        initializationResult: Result<UserState, AWSMobileClientError> = .success(.signedIn)
    ) {
        self.currentUserState = initialUserState
        self.initializationResult = initializationResult
    }

    // MARK: CredentialsProvider

    public var currentUserState: UserState

    public func initialize() -> Promise<UserState> {
        initializationPromise = .init()
        return initializationPromise
    }

    // MARK: - Helpers

    func completeInit() {
        switch initializationResult {
        case .success(let userState):
            initializationPromise.fulfill(userState)
        case .failure(let error):
            initializationPromise.reject(error)
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
