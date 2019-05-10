//
//  DateFormatter+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

extension DateFormatter {

    // https://grokswift.com/decodable-with-alamofire-4/
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // FIXME: change to TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // FIXME: change to TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let veryShortEDT: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "EDT")
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("M/d")
        return formatter
    }()

}
