//
//  NetworkClient.swift
// 
//
//  Created by Mathew Gacy on 6/4/21.
//

import Foundation
import Combine

// MARK: - Protocol

public protocol NetworkClientProtocol {

    /// Creates a resumable operation that performs the request, then calls a handler upon completion.
    /// - Parameters:
    ///   - request: The request to be performed.
    ///   - completion: The completion handler to be called when the request is complete.
    @discardableResult
    @inlinable
    func send<T: RequestProtocol>(
        _ request: T,
        _ completion: @escaping (Result<T.Response, NetworkClientError>) -> Void
    ) -> Resumable

    /// Returns a publisher that wraps the performance of request.
    /// - Parameter request: The request to be performed.
    func requestPublisher<T: RequestProtocol>(
        _ request: T
    ) -> AnyPublisher<T.Response, NetworkClientError>
}

// MARK: - Implementation

public final class NetworkClient: NetworkClientProtocol {
    @usableFromInline
    internal let session: URLSession

    /// Creates a client with the specified session configuration.
    /// - Parameter configuration: A configuration object that specifies certain behaviors, such as caching policies, timeouts, proxies, pipelining, TLS versions to support, cookie policies, credential storage, and so on.
    public init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }

    /// Creates a resumable operation that performs the request, then calls a handler upon completion.
    /// - Parameters:
    ///   - request: The request to be performed.
    ///   - completion: The completion handler to be called when the request is complete.
    @discardableResult
    @inlinable
    public func send<T: RequestProtocol>(
        _ request: T,
        _ completion: @escaping (Result<T.Response, NetworkClientError>) -> Void
    ) -> Resumable {
        session.perform(request, completionHandler: completion)
    }

    /// Returns a publisher that wraps the performance of request.
    /// - Parameter request: The request to be performed.
    //@inline(__always)
    public func requestPublisher<T: RequestProtocol>(
        _ request: T
    ) -> AnyPublisher<T.Response, NetworkClientError> {
        session.perform(request)
    }
}
