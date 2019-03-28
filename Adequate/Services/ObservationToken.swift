//
//  ObservationToken.swift
//  Adequate
//
//  John Sundell
//  https://www.swiftbysundell.com/posts/observers-in-swift-part-2
//

import Foundation

public class ObservationToken {
    private let cancellationClosure: () -> Void

    init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }

    func cancel() {
        cancellationClosure()
    }
}
