//
//  NetworkClient.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise
import MGNetworking

// MARK: - URLSession+Promise
extension URLSession {

    public func data(with request: URLRequest) -> Promise<Data> {
        return Promise<Data>(work: { fulfill, reject in
            self.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    reject(NetworkClientError.network(error: error))
                } else if let data = data, let httpResponse = response as? HTTPURLResponse {
                    do {
                        try httpResponse.validateStatus()
                        fulfill(data)
                    } catch {
                        reject(error)
                    }
                } else {
                    preconditionFailure("Neither response nor error.")
                    //reject(NetworkClientError.myError(message: "Bad response or missing data"))
                }
            }).resume()
        })
    }

}

// MARK: - Client

// MARK: Protocol

public protocol NetworkClientType {
    func request<T: Decodable>(_ url: URL) -> Promise<T>
    func request(_ url: URL) -> Promise<UIImage>
}

// MARK: Implementation

public class NetworkClient: NetworkClientType {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let queue = DispatchQueue(label: "com.mgacy.response-queue", qos: .userInitiated, attributes: [.concurrent])

    public init(configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.session = URLSession(configuration: configuration)
        self.decoder = decoder
    }

    public func request<T: Decodable>(_ url: URL) -> Promise<T> {
        let request = URLRequest(url: url)
        return session.data(with: request).then(on: queue, { data -> T in
            let responseObject = try self.decoder.decode(T.self, from: data)
            return responseObject
        })
    }

    public func request(_ url: URL) -> Promise<UIImage> {
        let request = URLRequest(url: url)
        return session.data(with: request).then(on: queue, { data -> UIImage in
            guard let image = UIImage(data: data) else {
                throw NetworkClientError.decoding(error: ImageError())
            }
            return image
        })
    }

}
