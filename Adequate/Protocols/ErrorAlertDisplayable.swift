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
}

extension UIViewController: ErrorAlertDisplayable {

    func displayError(error: Error, completion: (() -> Void)? = nil) {
        let message = "There was some error"
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: completion)
    }

}
