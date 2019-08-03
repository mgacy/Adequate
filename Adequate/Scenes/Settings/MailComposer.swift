//
//  MailComposer.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/1/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import MessageUI

class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    // TODO: use `Result<MFMailComposeResult, Error>`?
    typealias CompletionHandler = (MFMailComposeResult) -> Void

    var completionHandler: CompletionHandler?

    //deinit { print("\(#function) - \(String(describing: self))") }

    /// A wrapper function to indicate whether or not an email can be sent from the user's device
    static func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }

    /// Configures and returns a MFMailComposeViewController instance if current device is configured to send email
    func configuredMailComposeViewController(recipients: [String], subject: String? = nil, message: String? = nil, completionHandler: @escaping CompletionHandler) -> MFMailComposeViewController? {
        guard MailComposer.canSendMail() else {
            return nil
        }
        self.completionHandler = completionHandler

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self  //  Allow the controller to be dismissed

        // Configure the fields of the interface.
        mailComposerVC.setToRecipients(recipients)
        if subject != nil  {
            mailComposerVC.setSubject(subject!)
        }
        if message != nil  {
            mailComposerVC.setMessageBody(message!, isHTML: false)
        }

        return mailComposerVC
    }

    /// MFMailComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            // TODO: improve error handling
            log.error("\(error.localizedDescription)")
        }
        controller.dismiss(animated: true, completion: nil)
        completionHandler?(result)
    }
}
