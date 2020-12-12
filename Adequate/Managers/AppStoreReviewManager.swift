//
//  AppStoreReviewManager.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/11/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import StoreKit

struct AppStoreReviewManager {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    //func requestReviewIfAppropriate() {
    //    TODO: add logic to determine whether to request review
    //}

    func requestReview() {
        // Max 3 requests / year
        SKStoreReviewController.requestReview()

        defaults.set(Bundle.main.releaseVersionNumber, for: .lastVersionPromptedForReview)
    }
}
