//
//  BaseViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

class BaseViewController<T: UIView>: UIViewController {
    var rootView = T(frame: UIScreen.main.bounds)

    private var observationTokens: [ObservationToken] = []

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observationTokens = setupObservations()
    }

    deinit { observationTokens.forEach { $0.cancel() } }

    // MARK: - View Methods
    // TODO: move methods into protocol to which this class conforms?

    func setupView() {
        // ...
    }

    func setupObservations() -> [ObservationToken] {
        return []
    }
}
