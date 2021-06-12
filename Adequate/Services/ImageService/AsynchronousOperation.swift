//
//  AsynchronousOperation.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/11/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import Foundation
import protocol Combine.Cancellable

// From Apollo - /Apollo/Utilities/AsynchronousOperation.swift
class AsynchronousOperation: Operation, Cancellable {
    @objc class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        ["state"]
    }

    @objc class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        ["state"]
    }

    enum State {
        case initialized
        case ready
        case executing
        case finished
    }

    var state: State = .initialized {
        willSet {
            willChangeValue(forKey: "state")
        }
        didSet {
            didChangeValue(forKey: "state")
        }
    }

    override var isAsynchronous: Bool {
        true
    }

    override var isReady: Bool {
        let ready = super.isReady
        if ready {
            state = .ready
        }
        return ready
    }

    override var isExecuting: Bool {
        state == .executing
    }

    override var isFinished: Bool {
        state == .finished
    }
}
