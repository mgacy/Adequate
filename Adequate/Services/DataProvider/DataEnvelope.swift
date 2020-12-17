//
//  DataEnvelope.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import AWSAppSync

public typealias OperationResult<Data> = Swift.Result<DataEnvelope<Data>, SyncClientError>

public typealias OperationResultHandler<Data> = (OperationResult<Data>) -> Void

/// Represents the result of a GraphQL operation.
public struct DataEnvelope<Data> {

    /// Represents source of data.
    /// This type corresponds to `GraphQLResult.Source`.
    public enum Source {
        case cache
        case server

        public init<T>(_ source: DataEnvelope<T>.Source) {
            switch source {
            case .cache: self = .cache
            case .server: self = .server
            }
        }

        public init<T>(_ source: GraphQLResult<T>.Source) {
            switch source {
            case .cache: self = .cache
            case .server: self = .server
            }
        }
    }

    /// Source of the result.
    public let source: Source

    /// Result of the query operation.
    public let data: Data

    public init(source: Source, data: Data) {
        self.source = source
        self.data = data
    }
}

// MARK: - Operations
public extension DataEnvelope {

    func map<NewData>(_ transform: (Data) -> NewData) -> DataEnvelope<NewData> {
        DataEnvelope<NewData>(source: .init(source), data: transform(data))
    }
}

// MARK: - GraphQLResult+Ext

public extension GraphQLResult where Data: ResultSelectable {

    static func handleOperationResult(result: Self?, error: Error?) -> OperationResult<Data.ResultType?> {
        if let error = error {
            return .failure(.wrap(error))
        } else if let result = result {
            return result.envelop()
        } else {
            return .failure(.emptyOperationHandler)
        }
    }

    func envelop() -> OperationResult<Data.ResultType?> {
        if let errors = errors {
            return .failure(.graphQL(errors: errors))
        } else if let data = data {
            return .success(.init(source: .init(source), data: data[keyPath: Data.resultField]))
        } else {
            return .failure(.emptyResult)
        }
    }
}
