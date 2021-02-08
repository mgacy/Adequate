//
//  GraphQLQueryWatching.swift
//  Adequate
//
//  Created by Mathew Gacy on 2/6/21.
//  Copyright © 2021 Mathew Gacy. All rights reserved.
//

import AWSAppSync

public protocol GraphQLQueryWatching: Cancellable {
    //associatedtype Query: GraphQLQuery

    /// Refetch a query from the server.
    func refetch()
}

// MARK: - GraphQLQueryWatcher+GraphQLQueryWatching
extension GraphQLQueryWatcher: GraphQLQueryWatching {}
