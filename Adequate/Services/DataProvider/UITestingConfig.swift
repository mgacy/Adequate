//
//  UITestingConfig.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/23/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import AWSCore
import AWSAppSync

// TODO: relocate this; make more elegant
struct UITestingConfig: AWSAppSyncServiceConfigProvider {
    var endpoint: URL = URL(string: "http://localhost:9080/graphql")!
    let region: AWSRegionType = .USWest2
    let authType: AWSAppSyncAuthType = .apiKey
    let apiKey: String? = ""
    let clientDatabasePrefix: String? = nil
}
