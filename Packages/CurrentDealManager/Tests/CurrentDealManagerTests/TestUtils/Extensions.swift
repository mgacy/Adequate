//
//  TestUtils.swift
//
//
//  Created by Mathew Gacy on 1/6/21.
//

import UIKit
import Combine
import XCTest
import CurrentDealManager

// swiftlint:disable line_length

// MARK: - UIColor+Helper
public extension UIColor {

    func pngData(_ size: CGSize = CGSize(width: 1, height: 1)) -> Data {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.pngData { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }

    // https://stackoverflow.com/a/48441178/4472195
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

// Via John Sundell: https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        guard let url = URL(string: "\(value)") else {
            preconditionFailure("Invalid static URL string: \(value)")
        }
        self = url
    }
}

// MARK: - XCTestCase+Combine

extension XCTestCase {

    func await<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        try awaitResult(publisher, timeout: timeout, file: file, line: line).get()
    }

    func awaitError<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Failure {
        let result = try awaitResult(publisher, timeout: timeout, file: file, line: line)
        switch result {
        case .success(let value):
            XCTFail("Expected to be a failure but got a success with \(value)", file: file, line: line)
            throw XCTestError(.failureWhileWaiting)
        case .failure(let error):
            return error
        }
    }

    // Based on code by John Sundell:
    // https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/
    private func awaitResult<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Result<T.Output, T.Failure> {
        var result: Result<T.Output, T.Failure>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return unwrappedResult
    }
}

// MARK: - CurrentDeal

extension URL {
    static let gif: URL = "https://d2b8wt72ktn9a2.cloudfront.net/mediocre/image/upload/c_pad,f_auto,h_600,q_auto,w_600/psi6hyuuwmmj6oopqoiv.gif"
    static let deal: URL = "https://d2b8wt72ktn9a2.cloudfront.net/mediocre/image/upload/c_pad,f_auto,h_600,q_auto,w_600/j1cdevi8xm7iglxyy8qm.png"
    static let anotherDeal: URL = "https://d2b8wt72ktn9a2.cloudfront.net/mediocre/image/upload/c_pad,f_auto,h_600,q_auto,w_600/bgkysfggkhtg35wyam2c.png"
}

extension CurrentDeal {

    static var testDeal: CurrentDeal {
        return CurrentDeal(id: "a6k5A000000cWOLQA2",
                           title: "Pick-Your-2-Pack 500 or 1000 Piece Jigsaw Puzzles",
                           imageURL: .deal,
                           minPrice: 9,
                           maxPrice: 19.99,
                           launchStatus: .launch)
    }
}
