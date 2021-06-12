//
//  NetworkClient.swift
// 
//
//  Created by Mathew Gacy on 6/4/21.
//

import Foundation
import Combine

public protocol NetworkClientProtocol {

    /// Fetch any endpoint on the API.
    @discardableResult
    @inlinable
    func send<T: RequestProtocol>(
        _ request: T,
        _ completion: @escaping (Result<T.Response, NetworkClientError>) -> Void
    ) -> Resumable
}

public final class NetworkClient: NetworkClientProtocol {
    @usableFromInline
    internal let session: URLSession

    public init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }

    /// Fetch any endpoint on the API.
    @discardableResult
    @inlinable
    public func send<T: RequestProtocol>(
        _ request: T,
        _ completion: @escaping (Result<T.Response, NetworkClientError>) -> Void
    ) -> Resumable {
        session.perform(request, completionHandler: completion)
    }

    //@inline(__always)
    public func requestPublisher<T: RequestProtocol>(
        _ request: T
    ) -> AnyPublisher<T.Response, NetworkClientError> {
        session.perform(request)
    }
}
