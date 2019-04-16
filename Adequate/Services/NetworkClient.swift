//
//  NetworkClient.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

// MARK: - SessionProtocol

protocol SessionProtocol {
    func data(with request: URLRequest) -> Promise<Data>
}

extension URLSession: SessionProtocol {

    public func data(with request: URLRequest) -> Promise<Data> {
        return Promise<Data>(work: { fulfill, reject in
            //guard let urlRequest = request.urlRequest else {
            //    reject(ClientError.badRequest)
            //}
            self.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    reject(NetworkClientError.network(error: error))
                } else if let data = data, let httpResponse = response as? HTTPURLResponse {
                    httpResponse.validateStatus()
                    fulfill(data)
                } else {
                    //reject(NetworkClientError.myError(message: "Bad response or missing data"))
                    fatalError("Something has gone horribly wrong.")
                }
            }).resume()
        })
    }

}

// MARK: - HTTPURLResponse

/// TODO: - create protocol + add extension to validate .statusCode
/// See Alamofire: Validation.swift for ideas

/// var acceptableStatusCodes: [Int] { return Array(200..<300) }

protocol StatusCodeValidating {
    var statusCode: Int { get }
    func validateStatus()
}

extension HTTPURLResponse: StatusCodeValidating {
    func validateStatus() {
        /// TODO: throw if staus is invalid?
        /// TODO: return Error?
        /// TODO: return ValidationResult enum like Alamofire?
        //guard (200...299).contains(statusCode) else { return }
        print("Status Code: \(self.statusCode)")
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
                throw NetworkClientError.imageDecodingFailed
            }
            return image
        })
    }

}
