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
        //let file = FileDestination()

        // use custom format and set console output to short time, log level & message
        //console.format = "$DHH:mm:ss$d $L $M"
        // or use this for JSON output: console.format = "$J"

        // Filters

        #if !(arch(i386) || arch(x86_64)) && os(iOS)
        let platform = SBPlatformDestination(appID: AppSecrets.loggerAppID,
                                             appSecret: AppSecrets.loggerAppSecret,
                                             encryptionKey: AppSecrets.loggerEncryptionKey)
        //platform.analyticsUserName = "userName"
        /// TODO: try to get minLevel from defaults (so user can set verbose logging)
        platform.minLevel = .debug
        SwiftyBeaver.addDestination(platform)
        #endif

        SwiftyBeaver.addDestination(console)
        //SwiftyBeaver.addDestination(file)
        loggerLoaded = true
    }

    private static func checkIfLoggerIsLoaded() {
        if !loggerLoaded {
            self.setupLogger()
        }
    }

    // MARK: - A

    static func verbose(_ string: String) {
        custom(level: .verbose, message: string)
    }

    static func debug(_ string: String) {
        custom(level: .debug, message: string)
    }

    static func info(_ string: String) {
        custom(level: .info, message: string)
    }

    static func warning(_ string: String) {
        custom(level: .warning, message: string)
    }

    static func error(_ string: String) {
        custom(level: .error, message: string)
    }

    private static func custom(level: SwiftyBeaver.Level, message: String) {
        checkIfLoggerIsLoaded()
        SwiftyBeaver.custom(level: level, message: message)
    }
}
