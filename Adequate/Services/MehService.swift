//
//  MehService.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import Promise

// MARK: - Protocol

protocol MehServiceType {
    func getDeal() -> Promise<MehResponse>
}

// MARK: - Implementation

class MehService: MehServiceType {

    private let baseURLString = "https://api.meh.com/1/"
    private let apiKey = AppSecrets.apiKey
    private let client: NetworkClientType
    private var lastUpdate: Date?

    init(client: NetworkClientType) {
        self.client = client
    }

    func getDeal() -> Promise<MehResponse> {
        var urlComponents = URLComponents(string: baseURLString + "current.json")
        urlComponents?.queryItems = [URLQueryItem(name: "apikey", value: apiKey)]
        guard let url = urlComponents?.url else {
            return Promise<MehResponse>(error: NetworkClientError.badRequest)
        }
        //return client.request(url)

        return client.request(url).then({ [weak self] _ in
            self?.lastUpdate = Date()
        })
    }

}
