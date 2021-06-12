//
//  URLSession+Ext.swift
//  
//
//  Created by Mathew Gacy on 5/29/21.
//

import Foundation
import Combine

// MARK: - Resumable

public protocol Resumable: Cancellable {
    func resume()
}

extension URLSessionDataTask: Resumable {}

// MARK: - SessionProtocol

public protocol SessionProtocol {
    typealias CompletionHandler<T> = (Result<T, NetworkClientError>) -> Void

    @discardableResult
    @inlinable
    func perform<T: RequestProtocol>(
        _: T,
        completionHandler: @escaping CompletionHandler<T.Response>
    ) -> Resumable

    func perform<T: RequestProtocol>(_ request: T) -> AnyPublisher<T.Response, NetworkClientError>
}

extension URLSession: SessionProtocol {

    @discardableResult
    @inlinable
    public func perform<T: RequestProtocol>(
        _ request: T,
        completionHandler: @escaping CompletionHandler<T.Response>
    ) -> Resumable {
        dataTask(with: request.asURLRequest()) { data, response, error in
            if let error = error {
                completionHandler(.failure(NetworkClientError.network(error: error)))
            } else if let data = data {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(.invalidResponse(response)))
                    return
                }
                do {
                    try httpResponse.validateStatus()
                    let result = try request.decode(data)
                    completionHandler(.success(result))
                } catch let statusError as NetworkClientError {
                    completionHandler(.failure(statusError))
                } catch {
                    completionHandler(.failure(.decoding(error: error)))
                }
            } else {
                completionHandler(.failure(NetworkClientError.noData))
            }
        }
    }

    @inlinable
    public func perform<T: RequestProtocol>(_ request: T) -> AnyPublisher<T.Response, NetworkClientError> {
        dataTaskPublisher(for: request.asURLRequest())
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkClientError.invalidResponse(response)
                }
                try httpResponse.validateStatus()

                return try request.decode(data)
            }
            .mapError { NetworkClientError.wrap($0) }
            .eraseToAnyPublisher()
    }
}
