//
//  DealDelta.swift
//  Adequate
//
//  Created by Mathew Gacy on 7/22/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import Foundation

/// Representation of notification content.
struct DealDelta {
    let dealID: String
    let deltaType: DeltaType

    init?(userInfo: [AnyHashable : Any]) {
        guard
            let dealID = userInfo[NotificationPayloadKey.dealID] as? String,
            let deltaType = DeltaType(userInfo: userInfo) else {
                return nil
        }
        self.dealID = dealID
        self.deltaType = deltaType
    }
}

enum DeltaType {
    case newDeal//(dealURL: URL, imageURL: URL)
    case commentCount(Int)
    case launchStatus(LaunchStatus)

    init?(userInfo: [AnyHashable : Any]) {
        if
            let updateTypeString = userInfo[NotificationPayloadKey.deltaType] as? String,
            let updateType = ValueType(rawValue: updateTypeString) {

            switch updateType {
            //case .newDeal:
            //    self = .newDeal
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
        } else {
            self = .newDeal
            // TODO: have separate initializers for alert and silent notification?
            //guard
            //    let dealURLString = userInfo[NotificationPayloadKey.dealURL] as? String,
            //    let dealURL = URL(string: dealURLString),
            //    let imageURLString = userInfo[NotificationKey.imageURL] as? String,
            //    let imageURL = URL(string: imageURLString) else {
            //        return nil
            //}
            //self = .newDeal(dealURL: dealURL, imageURL: imageURL)
        }
    }

    /// Values for `NotificationPayloadKey.deltaType`
    enum ValueType: String {
        case commentCount
        case launchStatus
    }
}

extension DealDelta {

    enum DeltaApplicationError: Error {
        /// The `DealDelta` does not apply to `deal`.
        case invalidID
        /// The `DealDelta` involves changes to a missing object.
        case missingParentProperty // incompleteGraph
        /// `Affine.trySet` returned nil
        case nilTrySet // `opticFailure`?
        /// Tried to apply `DeltaType.newDeal` to a `Deal`, which doesn't really make sense.
        case invalidOperation
    }

    // TODO: throw `Error` or return `Result`?
    func apply(to deal: Deal) throws -> Deal? {
        guard deal.dealID == dealID else {
            throw DeltaApplicationError.invalidID
        }
        switch deltaType {
        case .newDeal:
            // TODO: how best to handle this? Trying to apply `DeltaType.newDeal` to a `Deal` is really a programming
            // error. The notification indicates we need to fetch the new current deal, but we already have it.
            // Alternatively, we could return `nil` and assume that we already have the updated Deal indicated by the
            // notification.
            throw DeltaApplicationError.invalidOperation
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
