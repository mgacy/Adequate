//
//  URLProtocolMock.swift
//  
//
//  Created by Mathew Gacy on 1/9/21.
//

import Foundation
import XCTest

// https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
// https://www.swiftbysundell.com/articles/testing-networking-logic-in-swift/
class URLProtocolMock: URLProtocol {

    static var testResponses = [URL: Result<Data, Error>]()

    // Handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // Required method
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let client = client else { return }

        do {
            let url = try XCTUnwrap(request.url)
            let result = try XCTUnwrap(Self.testResponses[url])

            switch result {
            case .success(let data):
                let response = try XCTUnwrap(HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                ))

                client.urlProtocol(self, didReceive: response,
                                   cacheStoragePolicy: .notAllowed)

                client.urlProtocol(self, didLoad: data)
            case .failure(let error):
                client.urlProtocol(self, didFailWithError: error)
            }
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        // Indicate we're finished
        client.urlProtocolDidFinishLoading(self)
    }

    // Required method
    override func stopLoading() { }
}
