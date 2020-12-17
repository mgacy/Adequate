//
//  ResultSelectable.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import AWSAppSync

/// Standardize access to the root data field of responses to AWS AppSync queries.
public protocol ResultSelectable {
    associatedtype ResultType // rename `RootType`?

    /// KeyPath for the field on the result data providing the primary selection set.
    static var resultField: KeyPath<Self, ResultType?> { get } // TODO: rename `rootDataField`?
}

public protocol ResultSelectableOperation: GraphQLOperation where Self.Data: ResultSelectable {}

public protocol ResultSelectableQuery: ResultSelectableOperation where Self: GraphQLQuery {}

public protocol ResultSelectableMutation: ResultSelectableOperation where Self: GraphQLMutation {}
