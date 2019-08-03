//
//  ErrorAlertDisplayable.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

protocol ErrorAlertDisplayable {
    func displayError(error: Error, completion: (() -> Void)?)
    func displayError(message: String, completion: (() -> Void)?)
}

extension UIViewController: ErrorAlertDisplayable {

    func displayError(error: Error, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: L10n.error, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: L10n.dismiss, style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: completion)
    }

    func displayError(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: L10n.error, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: L10n.dismiss, style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: completion)
    }
}
