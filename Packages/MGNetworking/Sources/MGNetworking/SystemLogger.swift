//
//  SystemLogger.swift
//  
//
//  Created by Mathew Gacy on 12/31/20.
//

import Foundation
import os.log

public protocol SystemLogging {
    func log(level: OSLogType, message: String, file: String, function: String, line: Int)
}

public class SystemLogger {

    public static var destination: SystemLogging?

    // MARK: - LoggingType

    public static func verbose(_ message: String, file: String = #file, function: String = #function,
                               line: Int = #line) {
        write(level: .debug, message: message, file: file, function: function, line: line)
    }

    public static func debug(_ message: String, file: String = #file, function: String = #function,
                             line: Int = #line) {
        write(level: .debug, message: message, file: file, function: function, line: line)
    }

    public static func info(_ message: String, file: String = #file, function: String = #function,
                            line: Int = #line) {
        write(level: .info, message: message, file: file, function: function, line: line)
    }

    public static func warning(_ message: String, file: String = #file, function: String = #function,
                               line: Int = #line) {
        write(level: .error, message: message, file: file, function: function, line: line)
    }

    public static func error(_ message: String, file: String = #file, function: String = #function,
                             line: Int = #line) {
        write(level: .error, message: message, file: file, function: function, line: line)
    }

    // MARK: - Private

    private static func write(level: OSLogType, message: String, file: String, function: String, line: Int) {
        destination?.log(level: level, message: message, file: file, function: function, line: line)
    }
}

// MARK: - Types
extension SystemLogger {

    public enum Subsystem: String {
        case main

        public var rawValue: String {
            switch self {
            case .main:
                return Bundle.main.bundleIdentifier!
            }
        }
    }

    public enum Category: String {
        case fileCache
    }

    // MARK: - SystemLogging

    @available(iOS, introduced: 13, deprecated: 14, message: "Use `New`")
    public struct OldWrapper: SystemLogging {

        private let log: OSLog

        public init(subsystem: SystemLogger.Subsystem, category: SystemLogger.Category) {
            self.log = OSLog(subsystem: subsystem.rawValue, category: category.rawValue)
        }

        public func log(level: OSLogType, message: String, file: String, function: String, line: Int) {
            os_log("%{public}@:%{public}@ - %{public}@", log: log, type: level, function, String(line), message)
        }
    }

    @available(iOS 14.0, *)
    public struct LogWrapper: SystemLogging {

        private let logger: Logger

        public init(subsystem: SystemLogger.Subsystem, category: SystemLogger.Category) {
            self.logger = Logger(subsystem: subsystem.rawValue, category: category.rawValue)
        }

        public func log(level: OSLogType, message: String, file: String, function: String, line: Int) {
            logger.log(level: level, "\(function):\(line) - \(message)")
        }
    }
}
