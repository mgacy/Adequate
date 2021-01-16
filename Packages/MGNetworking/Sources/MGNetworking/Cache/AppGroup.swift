//
//  AppGroup.swift
//  
//
//  Created by Mathew Gacy on 12/26/20.
//

import Foundation

public struct AppGroup: FileLocation {

    public let containerURL: URL?

    private let fileManager: FileManager = .default

    public init(appGroupID: String, pathComponent: String) {
        let appGroupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
        self.containerURL = appGroupURL?.appendingPathComponent(pathComponent, isDirectory: true)
    }
}

// MARK: - CustomStringConvertible
extension AppGroup: CustomStringConvertible {
    public var description: String {
        return "AppGroup: \(containerURL?.absoluteString ?? "MISSING PATH")"
    }
}
