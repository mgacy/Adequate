//
//  NotificationService.swift
//  NotificationService
//
//  Created by Mathew Gacy on 10/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    private let downloader = FileDownloader(appGroupID: .currentDeal)
    private let fileCache = FileCache(appGroupID: .currentDeal)
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        // Store for use in `serviceExtensionTimeWillExpire()`
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent,
              let urlString = bestAttemptContent.userInfo[NotificationPayloadKey.imageURL] as? String,
              let imageURL = URL(string: urlString)?.secure() else {
            contentHandler(request.content)
            return
        }
        // TODO: get `request.content.categoryIdentifier` and pass content to corresponding method

        let fileName = imageURL.lastPathComponent

        // Download image and modify notification content
        downloader.downloadFile(from: imageURL) { [weak fileCache] result in
            guard let url = try? result.get() else {
                contentHandler(bestAttemptContent)
                return
            }

            fileCache?.storeFile(at: url, as: fileName)

            if let imageAttachment = try? UNNotificationAttachment(identifier: .image, url: url) {
                bestAttemptContent.attachments.append(imageAttachment)
            }
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push
        // payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

// MARK: - Support
enum NotificationAttachmentID: String {

    /// Identifier for Deal image notification attachments.
    case image // `newDealImage`?
}

// MARK: - UNNotificationAttachment + NotificationAttachmentID
extension UNNotificationAttachment {

    convenience init(identifier: NotificationAttachmentID,
                     url: URL,
                     options: [AnyHashable: Any]? = nil
    ) throws {
        try self.init(identifier: identifier.rawValue, url: url, options: options)
    }
}
