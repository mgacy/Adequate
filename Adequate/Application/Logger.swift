//
//  Logger.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import SwiftyBeaver

class Logger: LoggingType {
    private static var loggerLoaded = false

    private static func setupLogger() {
        let logLevel = SwiftyBeaver.Level(rawValue: Configuration.logLevel) ?? .verbose

        let file = FileDestination()
        file.minLevel = logLevel
        file.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        // 2020-09-30 17:15:00.256 💚 DEBUG AppDelegate.application():22 - application(_:didFinishLaunchingWithOptions:) - nil

        SwiftyBeaver.addDestination(file)

        // Don't add `SBPlatformDestination` in simulator
        #if !(arch(i386) || arch(x86_64)) && os(iOS)
        switch Configuration.environment {
        case .development:
            let console = ConsoleDestination()
            SwiftyBeaver.addDestination(console)

            let platform = SBPlatformDestination(appID: AppSecrets.loggerAppID,
                                                 appSecret: AppSecrets.loggerAppSecret,
                                                 encryptionKey: AppSecrets.loggerEncryptionKey)
            platform.minLevel = logLevel
            SwiftyBeaver.addDestination(platform)
        case .staging:
            let platform = SBPlatformDestination(appID: AppSecrets.loggerAppID,
                                                 appSecret: AppSecrets.loggerAppSecret,
                                                 encryptionKey: AppSecrets.loggerEncryptionKey)
            platform.minLevel = logLevel
            SwiftyBeaver.addDestination(platform)
        default:
            break
        }
        #else
        let console = ConsoleDestination()
        SwiftyBeaver.addDestination(console)
        #endif

        loggerLoaded = true
    }

    private static func checkIfLoggerIsLoaded() {
        if !loggerLoaded {
            self.setupLogger()
        }
    }

    // MARK: Public

    /// Log something generally unimportant (lowest priority)
    ///
    /// - Parameters:
    ///   - message: the message to be logged
    ///   - file: the file from which this is being called
    ///   - function: the function from which this is being called
    ///   - line: the line from which this is being called
    static func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .verbose, message: message, file: file, function: function, line: line)
    }

    /// Log something which helps during debugging (low priority)
    ///
    /// - Parameters:
    ///   - message: the message to be logged
    ///   - file: the file from which this is being called
    ///   - function: the function from which this is being called
    ///   - line: the line from which this is being called
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .debug, message: message, file: file, function: function, line: line)
    }

    /// Log something which you are really interested but which is not an issue or error (normal priority)
    ///
    /// - Parameters:
    ///   - message: the message to be logged
    ///   - file: the file from which this is being called
    ///   - function: the function from which this is being called
    ///   - line: the line from which this is being called
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .info, message: message, file: file, function: function, line: line)
    }

    /// Log something which may cause big trouble soon (high priority)
    ///
    /// - Parameters:
    ///   - message: the message to be logged
    ///   - file: the file from which this is being called
    ///   - function: the function from which this is being called
    ///   - line: the line from which this is being called
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .warning, message: message, file: file, function: function, line: line)
    }

    /// Log something which will keep you awake at night (highest priority)
    ///
    /// - Parameters:
    ///   - message: the message to be logged
    ///   - file: the file from which this is being called
    ///   - function: the function from which this is being called
    ///   - line: the line from which this is being called
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .error, message: message, file: file, function: function, line: line)
    }

    static func custom(level: Level, message: String, file: String, function: String, line: Int) {
        checkIfLoggerIsLoaded()
        SwiftyBeaver.custom(level: level.sbLevel, message: message, file: file, function: function, line: line)
    }
}

// MARK: - Types
extension Logger {

    enum Level: Int, CustomStringConvertible {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4

        var description: String {
            switch self {
            case .verbose: return "VERBOSE"
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warning: return "WARNING"
            case .error: return "ERROR"
            }
        }

        var sbLevel: SwiftyBeaver.Level {
            switch self {
            case .verbose: return .verbose
            case .debug: return .debug
            case .info: return .info
            case .warning: return .warning
            case .error: return .error
            }
        }
    }
}
