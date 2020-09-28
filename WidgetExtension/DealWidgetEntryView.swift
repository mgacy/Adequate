//
//  DealWidgetEntryView.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import WidgetKit
import SwiftUI

struct DealWidgetEntryView : View {
    var entry: DealProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        DealWidgetEntryView(entry: DealEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
