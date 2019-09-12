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
                    //fatalError("Something has gone horribly wrong.")
                    reject(AWSMobileClientError.unknown(message: "Neither result nor error"))
                }
            }
        }
    }

    /// Signs in a user with the given username and password.
    ///
    /// - Parameters:
    ///   - username: username of the user.
    ///   - password: password of the user.
    ///   - validationData: validation data for this sign in.
    /// - Returns: A Promise with the sign in result.
    public func signIn(username: String, password: String, validationData: [String: String]? = nil) -> Promise<SignInResult> {
        return Promise<SignInResult> { fulfill, reject in
            self.signIn(username: username, password: password, validationData: validationData) { signInResult, error in
                if let error = error {
                    reject(error)
                } else if let signInResult = signInResult {
                    fulfill(signInResult)
                } else {
                    //fatalError("Something has gone horribly wrong.")
                    reject(AWSMobileClientError.unknown(message: "Neither result nor error"))
                }
            }
        }
    }

    /// Sign up with username, password and other attrbutes like phone, email.
    ///
    /// - Parameters:
    ///   - username: username of the user.
    ///   - password: password of the user
    ///   - userAttributes: user attributes which contain attributes like phone_number, email, etc.
    ///   - validationData: validation data for the user.
    /// - Returns: A Promise with the sign up result.
    public func signUp(username: String, password: String, userAttributes: [String: String] = [:], validationData: [String: String] = [:]) -> Promise<SignUpResult> {
        return Promise<SignUpResult> { fulfill, reject in
            self.signUp(username: username, password: password, userAttributes: userAttributes, validationData: validationData) { signUpResult, error in
                if let error = error {
                    reject(error)
                } else if let signUpResult = signUpResult {
                    fulfill(signUpResult)
                } else {
                    //fatalError("Something has gone horribly wrong.")
                    reject(AWSMobileClientError.unknown(message: "Neither result nor error"))
                }
            }
        }
    }

    /// Confirms a sign up for a user using a verification code.
    ///
    /// - Parameters:
    ///   - username: username of the user.
    ///   - confirmationCode: confirmation code sent to the user.
    /// - Returns: A Promise with the sign up result.
    public func confirmSignUp(username: String, confirmationCode: String) -> Promise<SignUpResult> {
        return Promise<SignUpResult> { fulfill, reject in
            self.confirmSignUp(username: username, confirmationCode: confirmationCode) { signUpResult, error in
                if let error = error {
                    reject(error)
                } else if let result = signUpResult {
                    fulfill(result)
                } else {
                    //fatalError("Something has gone horribly wrong.")
                    reject(AWSMobileClientError.unknown(message: "Neither result nor error"))
                }
            }
        }
    }

    /// Asynchronous signout method which requires network activity. Based on the options specified in `SignOutOptions`, appropriate tasks will be performed.
    ///
    /// - Parameters:
    ///   - options: SignOutOptions which specify actions.
    /// - Returns: A Promise.
    public func signOut(options: SignOutOptions = SignOutOptions()) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            self.signOut(options: options) { error in
                if let error = error {
                    reject(error)
                } else {
                    fulfill(())
                }
            }
        }
    }

    /// Fetches the `AWSCredentials` asynchronously.
    public func getAWSCredentials() -> Promise<AWSCredentials> {
        return Promise<AWSCredentials> { fulfill, reject in
            self.getAWSCredentials() { credentials, error in
                if let error = error {
                    reject(error)
                } else if let credentials = credentials {
                    fulfill(credentials)
                } else {
                    //fatalError("Something has gone horribly wrong.")
                    reject(AWSMobileClientError.unknown(message: "Neither result nor error"))
                }
            }
        }
    }

    /// Returns cached UserPools auth JWT tokens if valid.
    /// If the `idToken` is not valid, and a refresh token is available, refresh token is used to get a new `idToken`.
    /// If there is no refresh token and the user is signed in, a notification is dispatched to indicate requirement of user to re-signin.
    /// The call to wait will be synchronized so that if multiple threads call this method, they will block till the first thread gets the token.
    public func getTokens() -> Promise<Tokens> {
        return Promise<Tokens> { fulfill, reject in
            self.getTokens() { tokens, error in
                if let error = error {
                    reject(error)
                } else if let tokens = tokens {
                    fulfill(tokens)
                } else {
                    //fatalError("Something has gone horribly wrong.")
                    reject(AWSMobileClientError.unknown(message: "Neither result nor error"))
                }
            }
        }
    }
}
