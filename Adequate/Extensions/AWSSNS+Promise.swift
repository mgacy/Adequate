//
//  AWSSNS+Promise.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/29/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import AWSSNS
import Promise

extension AWSSNS {

    func createPlatformEndpoint(request: AWSSNSCreatePlatformEndpointInput) -> Promise<AWSSNSCreateEndpointResponse> {
        return Promise<AWSSNSCreateEndpointResponse>(work: { [weak self] fulfill, reject in
            self?.createPlatformEndpoint(request) { response, error in
                if let error = error {
                    reject(error)
                } else if let response = response {
                    fulfill(response)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }
        })
    }

    // MARK: - Subscriptions

    func listSubscriptions(request: AWSSNSListSubscriptionsInput) -> Promise<AWSSNSListSubscriptionsResponse> {
        return Promise<AWSSNSListSubscriptionsResponse>(work: { [weak self] fulfill, reject in
            self?.listSubscriptions(request) { response, error in
                if let error = error {
                    reject(error)
                } else if let response = response {
                    fulfill(response)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }
        })
    }

    func subscribe(request: AWSSNSSubscribeInput) -> Promise<AWSSNSSubscribeResponse> {
        return Promise<AWSSNSSubscribeResponse>(work: { [weak self] fulfill, reject in
            self?.subscribe(request) { response, error in
                if let error = error {
                    reject(error)
                } else if let response = response {
                    fulfill(response)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }
        })
    }

    func confirmSubscription(request: AWSSNSConfirmSubscriptionInput) -> Promise<AWSSNSConfirmSubscriptionResponse> {
        return Promise<AWSSNSConfirmSubscriptionResponse>(work: { [weak self] fulfill, reject in
            self?.confirmSubscription(request) { response, error in
                if let error = error {
                    reject(error)
                } else if let response = response {
                    fulfill(response)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }
        })
    }

    func unsubscribe(request: AWSSNSUnsubscribeInput) -> Promise<Void> {
        return Promise<Void>(work: { [weak self] fulfill, reject in
            self?.unsubscribe(request) { maybeError in
                if let error = maybeError {
                    reject(error)
                } else {
                    fulfill(())
                }
            }
        })
    }
}
