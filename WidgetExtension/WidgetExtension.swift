//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtension: Widget {
    let kind: String = "DealWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: DealProvider()
        ) { entry in
            DealWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
