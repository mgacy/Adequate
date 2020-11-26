//
//  DealNotification.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation
import typealias AWSAppSync.GraphQLID // = String

/// Representation of notification content.
enum DealNotification {
    case new(GraphQLID) // Use `NewDeal` struct with dealURL, imageURL?
    case delta(DealDelta)

    init?(userInfo: [AnyHashable : Any]) {
        guard let dealID = userInfo[NotificationPayloadKey.dealID] as? GraphQLID else {
            return nil
        }
        if let deltaTypeString = userInfo[NotificationPayloadKey.deltaType] as? String,
           let deltaValue = userInfo[NotificationPayloadKey.deltaValue]
        {
            guard let deltaType = DealDelta.DeltaType(typeString: deltaTypeString, value: deltaValue) else {
                return nil
            }
            self = .delta(DealDelta(dealID: dealID, deltaType: deltaType))
        } else {
            // We could try to extract NotificationPayloadKey.dealURL, NotificationPayloadKey.imageURL and initialize
            // `NewDeal` struct as a way to validate data
            self = .new(dealID)
        }
        return nil
    }
}

/// Representation of an update to the current Deal.
struct DealDelta {
    let dealID: GraphQLID
    let deltaType: DeltaType

    init?(userInfo: [AnyHashable : Any]) {
        guard let dealID = userInfo[NotificationPayloadKey.dealID] as? GraphQLID,
              let deltaType = DeltaType(userInfo: userInfo) else {
            return nil
        }
        self.init(dealID: dealID, deltaType: deltaType)
    }

    init?(dealID: GraphQLID, deltaTypeString: String, deltaValue: Any) {
        guard let type = DeltaType(typeString: deltaTypeString, value: deltaValue) else {
            return nil
        }
        self.init(dealID: dealID, deltaType: type)
    }

    init(dealID: GraphQLID, deltaType: DeltaType) {
        self.dealID = dealID
        self.deltaType = deltaType
    }
}

// MARK: - DealDelta + apply
extension DealDelta {

    // TODO: throw `Error` or return `Result`?
    func apply(to deal: Deal) throws -> Deal? {
        guard deal.dealID == dealID else {
            throw DeltaApplicationError.invalidID
        }
        switch deltaType {
        case .commentCount(let newCount):
            guard let currentTopic = deal.topic else {
                throw DeltaApplicationError.missingParentProperty
            }

            if newCount == currentTopic.commentCount {
                return nil
            }

            let dealAffine = Deal.lens.topic.toAffine()
            let topicPrism = Optional<Topic>.prism.toAffine()
            let topicAffine = Topic.lens.commentCount.toAffine()
            let composed = dealAffine.then(topicPrism).then(topicAffine)

            guard let updatedDeal = composed.trySet(newCount)(deal) else {
                throw DeltaApplicationError.nilTrySet
            }
            return updatedDeal
        case .launchStatus(let newStatus):
            if newStatus == deal.launchStatus {
                return nil
            }

            let launchStatusLens = Deal.lens.launchStatus
            return launchStatusLens.set(newStatus)(deal)
        }
    }
}

// MARK: - DealDelta + Types
extension DealDelta {

    /// Type of update to a Deal.
    enum DeltaType {
        /// Update `Deal.topic.commentCount`.
        case commentCount(Int)
        /// Update `Deal.launchStatus`.
        case launchStatus(LaunchStatus)

        init?(userInfo: [AnyHashable : Any]) {
            guard let updateTypeString = userInfo[NotificationPayloadKey.deltaType] as? String,
                  let updateType = ValueType(rawValue: updateTypeString) else {
                return nil
            }

            switch updateType {
            case .commentCount:
                guard let count = userInfo[NotificationPayloadKey.deltaValue] as? Int else {
                    return nil
                }
                self = .commentCount(count)
            case .launchStatus:
                guard
                    let status = userInfo[NotificationPayloadKey.deltaValue] as? String,
                    let launchStatus = LaunchStatus(rawValue: status) else {
                    return nil
                }
                self = .launchStatus(launchStatus)
            }
        }

        init?(typeString: String, value: Any) {
            guard let updateType = ValueType(rawValue: typeString) else {
                return nil
            }
            switch updateType {
            case .commentCount:
                guard let count = value as? Int else {
                    return nil
                }
                self = .commentCount(count)
            case .launchStatus:
                guard let status = value as? String,
                      let launchStatus = LaunchStatus(rawValue: status) else {
                    return nil
                }
                self = .launchStatus(launchStatus)
            }
        }

        /// Values for `NotificationPayloadKey.deltaType`.
        enum ValueType: String {
            case commentCount
            case launchStatus
        }
    }

    // TODO: should this be a top level type?
    enum DeltaApplicationError: Error {
        /// The `DealDelta` does not apply to `deal`.
        case invalidID
        /// The `DealDelta` involves changes to a missing object.
        case missingParentProperty // incompleteGraph
        /// `Affine.trySet` returned nil
        case nilTrySet // `opticFailure`?
    }
}
