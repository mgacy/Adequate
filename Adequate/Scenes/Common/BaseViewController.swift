//
//  BaseViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/27/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit
import Combine

class BaseViewController<T: UIView>: UIViewController {
    var rootView = T(frame: UIScreen.main.bounds)

    var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods
    // TODO: move methods into protocol to which this class conforms?

    func setupView() {
        // ...
    }
}
