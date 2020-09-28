//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

#if canImport(WidgetKit)
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
        .configurationDisplayName(L10n.widgetExtensionName)
        .description(L10n.widgetExtensionDescription)
    }
}
#endif
