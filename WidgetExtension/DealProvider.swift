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
        let dealImage = currentDealManager.readImage() ?? .placeholder

        let timeline = Timeline(entries: [DealEntry(deal: currentDeal, image: dealImage)], policy: .never)
        completion(timeline)
    }
}
#endif
