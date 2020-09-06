//
//  NotificationService.swift
//  NotificationService
//
//  Created by Mathew Gacy on 10/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    private let downloader = FileDownloader(appGroupID: .currentDeal)
    private let fileCache = FileCache(appGroupID: .currentDeal)

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {

            // Parse image url from bestAttemptContent?.userInfo
            guard
                let urlString = bestAttemptContent.userInfo[NotificationPayloadKey.imageURL] as? String,
                let url = URL(string: urlString)?.secure() else {
                    return contentHandler(request.content)
            }

            // TODO: make NotificationConstants an enum and define attachmentID as property of it?
            let attachmentID = "image"

            // Download image and modify notification content
            downloader.downloadFile(from: url, as: attachmentID) { url in
                guard
                    let url = url,
                    let attachment = try? UNNotificationAttachment(identifier: attachmentID, url: url) else {
                        return
                }
                bestAttemptContent.attachments.append(attachment)

                let fileName = url.lastPathComponent
                self.fileCache.storeFile(at: url, as: fileName)

                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
