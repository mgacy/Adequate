//
//  URLProtocolMock.swift
//  
//
//  Created by Mathew Gacy on 1/9/21.
//

import Foundation

// https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
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
        if let url = request.url {
            if let result = Self.testResponses[url] {
                switch result {
                case .success(let data):
                    self.client?.urlProtocol(self, didLoad: data)
                case .failure(let error):
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            }
        }

        // Indicate we're finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // Required method
    override func stopLoading() { }
}
