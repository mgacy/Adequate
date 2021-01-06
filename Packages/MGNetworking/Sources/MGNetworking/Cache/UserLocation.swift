//
//  UserLocation.swift
//  
//
//  Created by Mathew Gacy on 12/26/20.
//

import Foundation

public enum UserLocation: FileLocation {
    public typealias PathComponent = String

    case document(PathComponent)
    case cache(PathComponent)
    case temp(PathComponent)

    public var containerURL: URL? {
        return baseURL?.appendingPathComponent(pathComponent)
    }

    // MARK: - Private

    private var fileManager: FileManager {
        return .default
    }

    private var baseURL: URL? {
        switch self {
        case .document:
            return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        case .cache:
            return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        case .temp:
            return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
    }

    private var pathComponent: PathComponent {
        switch self {
        case .document(let component): return component
        case .cache(let component): return component
        case .temp(let component): return component
        }
    }
}
