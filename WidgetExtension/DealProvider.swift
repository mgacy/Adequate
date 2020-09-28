//
//  DealProvider.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import WidgetKit
//import SwiftUI

struct DealEntry: TimelineEntry {
    let date: Date
}

struct DealProvider: TimelineProvider {
    typealias Entry = DealEntry

    func placeholder(in context: Context) -> DealEntry {
        DealEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DealEntry) -> ()) {
        let entry = DealEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DealEntry>) -> ()) {
        var entries: [DealEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DealEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
