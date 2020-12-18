//
//  FileLoader.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/21/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

class FileLoader {

    static func loadData<T: RawRepresentable>(
        from resource: T,
        in bundle: Bundle = .main
    ) throws -> Data where T.RawValue == String {
        guard let url = bundle.url(forResource: resource.rawValue, withExtension: "json") else {
            throw FileLoaderError.missingFile
        }
        return try Data(contentsOf: url)
    }

    static func loadJSON<T: RawRepresentable>(
        from resource: T,
        in bundle: Bundle = .main
    ) throws -> [String: Any] where T.RawValue == String {
        let data = try loadData(from: resource, in: bundle)
        // swiftlint:disable:next force_cast
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
    }

    // MARK: - Types

    public enum FileLoaderError: Error {
        case missingFile
    }
}
