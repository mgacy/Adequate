//
//  DealProvider.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

#if canImport(WidgetKit)
import UIKit
import WidgetKit
import CurrentDealManager

struct DealProvider: TimelineProvider {
    typealias Entry = DealEntry

    let currentDealManager = CurrentDealManager()

    func placeholder(in context: Context) -> Entry {
        DealEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry: DealEntry
        if context.isPreview {
            entry = .placeholder
        } else {
            if let currentDeal = currentDealManager.readDeal(), let dealImage = currentDealManager.readImage() {
                entry = DealEntry(deal: currentDeal, image: dealImage)
            } else {
                entry = .placeholder
            }
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDeal = currentDealManager.readDeal() ?? .placeholder
        // TODO: add alternative image asset or use photo symbol to represent image load errors?
        let dealImage = currentDealManager.readImage() ?? .placeholder

        // Request a timeline refresh after 2.5 hours.
        let date = Calendar.current.date(byAdding: .minute, value: 150, to: Date())!
        let timeline = Timeline(entries: [DealEntry(deal: currentDeal, image: dealImage)],
                                policy: .after(date))
        completion(timeline)
    }
}

// MARK: - Helpers for Fastlane Snapshots
extension DealProvider {

    func mockTimelineForSnapshot(in context: Context) -> Timeline<DealEntry> {
        let currentDeal = CurrentDeal.appStoreMock
        let dealImage = UIImage.appStoreMock
        return Timeline(entries: [DealEntry(deal: currentDeal, image: dealImage)], policy: .never)
    }
}

#endif
