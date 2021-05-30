//
//  Combine+Logging.swift
//  Adequate
//
//  Created by Mathew Gacy on 1/29/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import SwiftyBeaver
import Combine

class LogCancellable: Cancellable {
    let wrapped: AnyCancellable
    let id: String?
    let level: Logger.Level
    let file: String
    let function: String
    let line: Int

    init(_ wrapped: AnyCancellable,
         id: String?,
         level: Logger.Level = .verbose,
         file: String,
         function: String,
         line: Int) {
        self.wrapped = wrapped
        self.id = id
        self.level = level
        self.file = file
        self.function = function
        self.line = line

        let message = id != nil ? "Cancellable: init \(id!)" : "Cancellable: init"
        log(message: message)
    }

    func cancel() {
        wrapped.cancel()
        let message = id != nil ? "Cancellable: cancel \(id!)" : "Cancellable: cancel"
        log(message: message)
    }

    deinit {
        let message = id != nil ? "Cancellable: deinit \(id!)" : "Cancellable: deinit"
        log(message: message)
    }

    private func log(message: String) {
        switch level {
        case .verbose:
            Logger.verbose(message, file: file, function: function, line: line)
        case .debug:
            Logger.debug(message, file: file, function: function, line: line)
        case .info:
            Logger.info(message, file: file, function: function, line: line)
        case .warning:
            Logger.warning(message, file: file, function: function, line: line)
        case .error:
            Logger.error(message, file: file, function: function, line: line)
        }
    }
}

// MARK: - Cancellable+Logging
extension Cancellable {

    func logCancellable(
        id: String? = nil,
        level: Logger.Level = .verbose,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> AnyCancellable {
        return AnyCancellable(LogCancellable(AnyCancellable(self), id: id, level: level, file: file,
                                             function: function, line: line))
    }
}

// MARK: - Publisher+Logging
extension Publisher {

    func logSink(
        id: String? = nil,
        level: Logger.Level = .verbose,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> AnyCancellable {
        return sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    let message = id != nil ? "Sink: \(completion) \(id!)" : "Sink: \(completion)"
                    Logger.custom(level: level, message: message, file: file, function: function,
                                        line: line)
                case .failure(let failure):
                    let message = "Sink: \(failure)"
                    Logger.custom(level: .error, message: message, file: file, function: function,
                                        line: line)
                }
            },
            receiveValue: { value in
                let message = id != nil ? "Sink: received \(value) \(id!)" : "Sink: receive \(value)"
                Logger.custom(level: level, message: message, file: file, function: function, line: line)
            })
    }
}
