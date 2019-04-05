//
//  Logger.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

class Logger: LoggingType {

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

    class func custom(level: Level, message: String) {
        print("\(level): \(message)")
    }
}
