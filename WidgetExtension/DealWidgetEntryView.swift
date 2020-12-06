//
//  DealWidgetEntryView.swift
//  WidgetExtension
//
//  Created by Mathew Gacy on 9/27/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

#if canImport(WidgetKit)
import WidgetKit
import SwiftUI

struct InfoView: View {
    @Environment(\.widgetFamily) var size
    var deal: CurrentDeal

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var priceString: String {
        let formattedMinPrice = formatter.string(from: deal.minPrice as NSNumber) ?? "\(deal.minPrice)"
        if let maxPrice = deal.maxPrice {
            let formattedMaxPrice = formatter.string(from: maxPrice as NSNumber) ?? "\(maxPrice)"
            return "$\(formattedMinPrice) - \(formattedMaxPrice)"
        } else {
            return "$\(formattedMinPrice)"
        }
    }

    var spacing: CGFloat? {
        if case .systemSmall = size {
             return nil
        } else {
            return 3
        }
    }

    var lineLimit: Int {
        if case .systemMedium = size {
            return 4
        } else {
            return 2
        }
    }

    var titleFont: Font {
        if case .systemSmall = size {
            return .system(size: 13, weight: .semibold, design: .default)
        } else {
            return .headline
        }
    }

    var priceFont: Font {
        if case .systemSmall = size {
            return .caption
        } else {
            return .footnote
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(deal.title)
                .font(titleFont)
                .lineLimit(lineLimit)
            Text(priceString)
                .foregroundColor(.secondary)
                .font(priceFont)
        }
    }
}

struct DealWidgetEntryView: View {
    @Environment(\.widgetFamily) var size
    var entry: DealProvider.Entry

    var body: some View {
        switch size {
        case .systemSmall:
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: entry.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(ContainerRelativeShape())
                    Spacer()
                }
                InfoView(deal: entry.deal)
            }
            .padding()
            .background(Color("DealWidgetBackground"))

        case .systemMedium:
            HStack(alignment: .top) {
                Image(uiImage: entry.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(ContainerRelativeShape())
                InfoView(deal: entry.deal)
                Spacer()
            }
            .padding()
            .background(Color("DealWidgetBackground"))

        case .systemLarge:
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: entry.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(ContainerRelativeShape())
                    Spacer()
                }
                InfoView(deal: entry.deal)
            }
            .padding()
            .background(Color("DealWidgetBackground"))

        @unknown default:
            VStack(alignment: .leading) {
                Image(uiImage: entry.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(ContainerRelativeShape())
                InfoView(deal: entry.deal)
            }
            .padding()
            .background(Color("DealWidgetBackground"))
        }
    }
    //.widgetURL(DEEPLINK)
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DealWidgetEntryView(entry: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            DealWidgetEntryView(entry: .placeholder).environment(\.colorScheme, .dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
        DealWidgetEntryView(entry: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        DealWidgetEntryView(entry: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
