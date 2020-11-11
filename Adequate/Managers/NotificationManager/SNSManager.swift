//
//  SNSManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 10/9/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import AWSSNS
import Promise

// MARK: - Errors
enum SNSManagerError: Error {
    case invalidInput
    case missingARN
}

// MARK: - Implementation
class SNSManager: NotificationServiceManager {
    private typealias ServiceARN = String

    private var sns: AWSSNS!
    private let queue = DispatchQueue(label: "com.mgacy.aws-queue", qos: .userInitiated, attributes: [.concurrent])

    // MARK: - Lifecycle

    init(region: AWSRegionType) {
        configureService(region: region)
        self.sns = AWSSNS.default()
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - NotificationServiceManager

    /// Register device with AWS SNS
    /// - Parameter token: Unique token identifying this device with Apple Push Notification service.
    /// - Returns: ARN for SNS subscription.
    func registerDevice(with token: String) -> Promise<String> {
        UserDefaults.standard.set(token, forKey: "deviceTokenForSNS")

        return createPlatformEndpoint(with: token)
            .then(on: queue, { endpointArn -> Promise<String> in
                UserDefaults.standard.set(endpointArn, forKey: "endpointArnForSNS")
                return self.subscribeToTopic(topicArn: AppSecrets.topicArn, endpointArn: endpointArn)
            })
            .then({ subscriptionArn in
                UserDefaults.standard.set(subscriptionArn, forKey: "subscriptionArnForSNS")
            })
    }

    // MARK: - Private

    private func configureService(region: AWSRegionType) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region,
                                                                identityPoolId: AppSecrets.identityPoolId)
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    private func createPlatformEndpoint(with token: String) -> Promise<ServiceARN> {
        guard let request = AWSSNSCreatePlatformEndpointInput() else {
            return Promise(error: SNSManagerError.invalidInput)
        }
        request.token = token
        #if DEBUG
        request.platformApplicationArn = AppSecrets.platformApplicationArn
        #else
        request.platformApplicationArn = AppSecrets.platformApplicationArnProd
        #endif

        return sns.createPlatformEndpoint(request: request)
            .then({ try $0.endpointArn.unwrap() })
    }

    private func subscribeToTopic(topicArn: ServiceARN, endpointArn: ServiceARN) -> Promise<ServiceARN> {
        guard let request = AWSSNSSubscribeInput() else {
            return Promise(error: SNSManagerError.invalidInput)
        }
        request.protocols = "application"
        request.topicArn = topicArn
        request.endpoint = endpointArn

        return sns.subscribe(request: request)
            .then({ try $0.subscriptionArn.unwrap() })
    }
    /*
    private func confirmSubscription(topicArn: String, deviceToken: String) -> Promise<ServiceARN> {
        guard let request = AWSSNSConfirmSubscriptionInput() else {
            return Promise(error: SNSManagerError.invalidInput)
        }
        request.topicArn = topicArn
        request.token = deviceToken

        return sns.confirmSubscription(request: request)
            .then({ try $0.subscriptionArn.unwrap() })
    }
    */
}
