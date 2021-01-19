//
//  SystemLoggerTests.swift
//  
//
//  Created by Mathew Gacy on 1/18/21.
//

import XCTest
import os.log
@testable import MGNetworking

class SystemLoggerTests: XCTestCase {

    // MARK: - A

    //override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        SystemLogger.destination = nil
    }

    // MARK: - B

    func testConfig() {
        //let subsystem = SystemLogger.Subsystem.main
        //let category = SystemLogger.Category.fileCache

        var logger: SystemLogging
        if #available(iOS 14.0, *) {
            logger = SystemLogger.LogWrapper(subsystem: .main, category: .fileCache)
        } else {
            logger = SystemLogger.OldWrapper(subsystem: .main, category: .fileCache)
        }

        // ...
    }

    func testLogger() {
        var logger: SystemLogging
        if #available(iOS 14.0, *) {
            logger = SystemLogger.LogWrapper(subsystem: .main, category: .fileCache)
        } else {
            logger = SystemLogger.OldWrapper(subsystem: .main, category: .fileCache)
        }
        SystemLogger.destination = logger
        let log = SystemLogger.self

        let message = "This is a test"
        //let file = "Test.swift"
        //let function = "foo()"
        //let line = 21

        log.verbose(message)
        log.debug(message)
        log.info(message)
        log.warning(message)
        log.error(message)
    }
}

// MARK: - Types
class SystemLoggingMock: SystemLogging {

    var lastLevel: OSLogType?
    var lastMessage: String?
    var lastFile: String?
    var lastFunction: String?
    var lastLine: Int?

    func log(level: OSLogType, message: String, file: String, function: String, line: Int) {
        lastMessage = message
        lastFile = file
        lastFunction = function
        lastLine = line
    }
}
