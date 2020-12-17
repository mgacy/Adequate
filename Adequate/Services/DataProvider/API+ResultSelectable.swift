//
//  API+ResultSelectable.swift
//  Adequate
//
//  Created by Mathew Gacy on 11/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation

// MARK: - GetDealQuery: + ResultSelectable
extension GetDealQuery: ResultSelectableQuery {}

extension GetDealQuery.Data: ResultSelectable {
    public static var resultField: KeyPath<Self, GetDeal?> {
        return \.getDeal
    }
}

// MARK: - DealHistoryQuery + ResultSelectable
extension DealHistoryQuery: ResultSelectableQuery {}

extension DealHistoryQuery.Data: ResultSelectable {
    public static var resultField: KeyPath<Self, DealHistory?> {
        return \.dealHistory
    }
}

// MARK: - ListDealsQuery + ResultSelectable
extension ListDealsQuery: ResultSelectableQuery {}

extension ListDealsQuery.Data: ResultSelectable {
    public static var resultField: KeyPath<Self, ListDeal?> {
        return \.listDeals
    }
}

// MARK: - SyncDealsQuery + ResultSelectable
extension SyncDealsQuery: ResultSelectableQuery {}

extension SyncDealsQuery.Data: ResultSelectable {
    public static var resultField: KeyPath<Self, SyncDeal?> {
        return \.syncDeals
    }
}

// MARK: - CreateDealMutation + ResultSelectable
extension CreateDealMutation: ResultSelectableMutation {}

extension CreateDealMutation.Data: ResultSelectable {
    public static var resultField: KeyPath<Self, CreateDeal?> {
        return \.createDeal
    }
}

// MARK: - UpdateDealMutation + ResultSelectable
extension UpdateDealMutation: ResultSelectableMutation {}

extension UpdateDealMutation.Data: ResultSelectable {
    public static var resultField: KeyPath<Self, UpdateDeal?> {
        return \.updateDeal
    }
}

// MARK: - DeleteDealMutation + ResultSelectable
extension DeleteDealMutation: ResultSelectableMutation {}

extension DeleteDealMutation.Data: ResultSelectable {
    public static var resultField: KeyPath<Self, DeleteDeal?> {
        return \.deleteDeal
    }
}
