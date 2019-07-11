//
//  Logger.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import SwiftyBeaver

class Logger: LoggingType {
    /*
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
    }
    */
    private static var loggerLoaded = false

    private static func setupLogger() {
        let console = ConsoleDestination()
        let file = FileDestination()

        // use custom format and set console output to short time, log level & message
        //console.format = "$DHH:mm:ss$d $L $M"
        // or use this for JSON output: console.format = "$J"

        // Filters

        #if !(arch(i386) || arch(x86_64)) && os(iOS)
        let platform = SBPlatformDestination(appID: AppSecrets.loggerAppID,
                                             appSecret: AppSecrets.loggerAppSecret,
                                             encryptionKey: AppSecrets.loggerEncryptionKey)
        //platform.analyticsUserName = "userName"
        // TODO: try to get minLevel from defaults (so user can set verbose logging)
        platform.minLevel = .verbose
        SwiftyBeaver.addDestination(platform)
        #endif

        SwiftyBeaver.addDestination(console)
        SwiftyBeaver.addDestination(file)
        loggerLoaded = true
    }

    private static func checkIfLoggerIsLoaded() {
        if !loggerLoaded {
            self.setupLogger()
        }
    }

    // MARK: Public

    static func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .verbose, message: message, file: file, function: function, line: line)
    }

    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .debug, message: message, file: file, function: function, line: line)
    }

    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .info, message: message, file: file, function: function, line: line)
    }

    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .warning, message: message, file: file, function: function, line: line)
    }

    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        custom(level: .error, message: message, file: file, function: function, line: line)
    }

    private static func custom(level: SwiftyBeaver.Level, message: String, file: String, function: String, line: Int) {
        checkIfLoggerIsLoaded()
        SwiftyBeaver.custom(level: level, message: message, file: file, function: function, line: line)
    }
}
