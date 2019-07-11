//
//  LoggingType.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/4/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

protocol LoggingType {

    /// Log something generally unimportant (lowest priority)
    ///
    /// - Parameter message: The data to be logged as string.
    static func verbose(_ message: String, file: String, function: String, line: Int)

    /// Log something which help during debugging (low priority)
    ///
    /// - Parameter message: The data to be logged as string.
    static func debug(_ message: String, file: String, function: String, line: Int)

    /// Log something which you are really interested but which is not an issue or error (normal priority)
    ///
    /// - Parameter message: The data to be logged as string.
    static func info(_ message: String, file: String, function: String, line: Int)

    /// Log something which may cause big trouble soon (high priority)
    ///
    /// - Parameter message: The data to be logged as string.
    static func warning(_ message: String, file: String, function: String, line: Int)

    /// Log something which will keep you awake at night (highest priority)
    ///
    /// - Parameter message: The data to be logged as string.
    static func error(_ message: String, file: String, function: String, line: Int)

}
