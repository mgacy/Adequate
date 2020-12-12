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
    case timeout
}

// MARK: - Configuration
protocol SNSManagerConfiguration {
    static var serviceRegion: AWSRegionType { get }
    static var platformApplicationArn: String { get }
    static var topicArn: String { get }
}

extension AppSecrets: SNSManagerConfiguration {}

// MARK: - Implementation
class SNSManager: NotificationServiceManager {
    private typealias ServiceARN = String

    private let configuration: SNSManagerConfiguration.Type
    private let sns: AWSSNS
    private let queue = DispatchQueue(label: "com.mgacy.aws-queue", qos: .userInitiated, attributes: [.concurrent])
    private let defaults: UserDefaults

    // MARK: - Lifecycle

    init(configuration: SNSManagerConfiguration.Type,
         credentialsProvider: AWSCredentialsProvider,
         defaults: UserDefaults = .standard
    ) {
        self.configuration = configuration
        self.sns = SNSManager.configureService(region: configuration.serviceRegion,
                                               credentialsProvider: credentialsProvider)
        self.defaults = defaults
    }

    //deinit { print("\(#function) - \(String(describing: self))") }

    // MARK: - NotificationServiceManager

    /// Register device with AWS SNS
    /// - Parameter token: Unique token identifying this device with Apple Push Notification service.
    /// - Returns: ARN for SNS subscription.
    func registerDevice(with token: String) -> Promise<String> {
        defaults.set(token, for: .SNSToken)

        return createPlatformEndpoint(with: token)
            .then(on: queue, { [weak self] endpointArn -> Promise<String> in
                guard let strongSelf = self else {
                    throw SNSManagerError.timeout
                }
                strongSelf.defaults.set(endpointArn, for: .SNSEndpoint)
                return strongSelf.subscribeToTopic(topicArn: strongSelf.configuration.topicArn,
                                                   endpointArn: endpointArn)
            })
            .then({ [weak defaults] subscriptionArn in
                defaults?.set(subscriptionArn, for: .SNSSubscription)
            })
    }

    /// Unsubscribe device from push notification service provider.
    func unsubscribeDevice() -> Promise<Void> {
        guard let subscriptionArn = defaults.string(for: .SNSSubscription) else {
            return Promise(error: SNSManagerError.missingARN)
        }
        return unsubscribe(subscriptionArn: subscriptionArn)
    }

    // MARK: - Private

    private static func configureService(region: AWSRegionType, credentialsProvider: AWSCredentialsProvider) -> AWSSNS {
        // TODO: should this be done in `AppDependency`?
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        return AWSSNS.default()
    }

    private func createPlatformEndpoint(with token: String) -> Promise<ServiceARN> {
        guard let request = AWSSNSCreatePlatformEndpointInput() else {
            return Promise(error: SNSManagerError.invalidInput)
        }
        request.token = token
        request.platformApplicationArn = configuration.platformApplicationArn

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
    private func unsubscribe(subscriptionArn: ServiceARN) -> Promise<Void> {
        guard let request = AWSSNSUnsubscribeInput() else {
            return Promise(error: SNSManagerError.invalidInput)
        }
        request.subscriptionArn = subscriptionArn
        return sns.unsubscribe(request: request)
    }
}
