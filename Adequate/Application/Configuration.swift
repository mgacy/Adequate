//
//  Configuration.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

// https://nshipster.com/xcconfig/
enum Configuration {

    enum Environment: String {
        case development
        case staging
        case production
    }

    enum Key: String {
        case buildConfiguration = "_CONFIGURATION"
        case envName = "_ENV_NAME"
        case logLevel = "_LOG_LEVEL"
    }

    static func value<T>(for key: Key) -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
            fatalError("Missing Configuration.Key: \(key.rawValue)")
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            fatalError("Invalid Type for Configuration.Key \(key.rawValue): \(T.self)")
        }
    }
}

extension Configuration {

    static var configuration: String {
        return Configuration.value(for: .buildConfiguration)
    }

    static var environment: Environment {
        return Environment(rawValue: Configuration.value(for: .envName)) ?? .development
    }

    static var logLevel: Int {
        return Configuration.value(for: .logLevel)
    }
}
