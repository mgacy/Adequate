//
//  SystemLogger.swift
//  
//
//  Created by Mathew Gacy on 12/31/20.
//

import Foundation
import os.log

// swiftlint:disable function_parameter_count

public class SystemLogger {

    public static var configuration: Configuration?

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
        switch configuration {
        case .osLog(let log):
            writeOld(log: log, level: level, message: message, file: file, function: function, line: line)
        default:
            if #available(iOS 14, *) {
                guard case .logger(let logger) = configuration else {
                    return
                }
                writeNice(logger: logger, level: level, message: message, file: file, function: function, line: line)
            }
        }
    }

    @available(iOS, introduced: 13, deprecated: 14, message: "Use `Configuration.logger`")
    private static func writeOld(log: OSLog, level: OSLogType, message: String, file: String, function: String, line: Int) {
        os_log("%{public}@:%{public}@ - %{public}@", log: log, type: level, function, line, message)
    }

    @available(iOS 14, *)
    private static func writeNice(logger: Logger, level: OSLogType, message: String, file: String, function: String, line: Int) {
        logger.log(level: level, "\(function):\(line) - \(message)")
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

    public enum Configuration {
        // TODO: try to use `obsoleted`
        @available(iOS, introduced: 13, deprecated: 14, message: "Use `Configuration.logger`")
        case osLog(OSLog)

        @available(iOS 14.0, *)
        case logger(Logger)

        public init(subsystem: Subsystem, category: Category) {
            if #available(iOS 14, *) {
                self = .logger(Logger(subsystem: subsystem.rawValue, category: category.rawValue))
            } else {
                self = .osLog(OSLog(subsystem: subsystem.rawValue, category: category.rawValue))
            }
        }
    }
}
