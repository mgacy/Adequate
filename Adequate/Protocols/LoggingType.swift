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
    /// - Parameter string: The data to be logged as string.
    static func verbose(_ string: String)

    /// Log something which help during debugging (low priority)
    ///
    /// - Parameter string: The data to be logged as string.
    static func debug(_ string: String)

    /// Log something which you are really interested but which is not an issue or error (normal priority)
    ///
    /// - Parameter string: The data to be logged as string.
    static func info(_ string: String)

    /// Log something which may cause big trouble soon (high priority)
    ///
    /// - Parameter string: The data to be logged as string.
    static func warning(_ string: String)

    /// Log something which will keep you awake at night (highest priority)
    ///
    /// - Parameter string: The data to be logged as string.
    static func error(_ string: String)

}
