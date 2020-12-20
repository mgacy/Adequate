//
//  MailComposer.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/1/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import MessageUI

final class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    typealias CompletionHandler = (Result<MFMailComposeResult, Error>) -> Void

    var completionHandler: CompletionHandler?

    //deinit { print("\(#function) - \(String(describing: self))") }

    /// A wrapper function to indicate whether or not an email can be sent from the user's device
    static func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }

    /// Configures and returns a MFMailComposeViewController instance if current device is configured to send email
    func configuredMailComposeViewController(recipients: [String],
                                             subject: String? = nil,
                                             message: String? = nil,
                                             attachments: [MailAttachment]? = nil,
                                             completionHandler: @escaping CompletionHandler
    ) -> MFMailComposeViewController? {
        guard MailComposer.canSendMail() else {
            return nil
        }
        self.completionHandler = completionHandler

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self  //  Allow the controller to be dismissed

        // Configure the fields of the interface.
        mailComposerVC.setToRecipients(recipients)
        if let subject = subject {
            mailComposerVC.setSubject(subject)
        }
        if let message = message {
            mailComposerVC.setMessageBody(message, isHTML: false)
        }
        if let attachments = attachments {
            mailComposerVC.addAttachmentData(attachments)
        }

        return mailComposerVC
    }

    /// MFMailComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?
    ) {
        controller.dismiss(animated: true) { [weak self] in
            if let error = error {
                self?.completionHandler?(.failure(error))
                //} else if case .failed = result {
            } else {
                self?.completionHandler?(.success(result))
            }
        }
    }
}

// MARK: - Types
extension MailComposer {

    /// MIME type for email attachments.
    /// see http://www.iana.org/assignments/media-types/
    enum MIME: String {
        case jpeg = "image/jpeg"
        case text = "text/txt"
    }

    struct MailAttachment {
        let data: Data
        let mimeType: MIME
        let fileName: String
    }
}

// MARK: - MFMailComposeViewController+MailAttachment
extension MFMailComposeViewController {

    /// Adds the specified attachment to the message.
    /// - Parameter attachments: container for data, MIME type and filename to attach to the message.
    func addAttachmentData(_ attachments: [MailComposer.MailAttachment]) {
        attachments.forEach { addAttachmentData($0.data, mimeType: $0.mimeType.rawValue, fileName: $0.fileName) }
    }
}
