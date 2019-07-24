//
//  API+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 3/11/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

extension LaunchStatus: Codable {}

extension ThemeForeground: Codable {

    var textColor: UIColor {
        switch self {
        case .dark: return .black
        case .light: return .white
        case .unknown: return .yellow
        }
    }

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark: return .default
        case .light: return .lightContent
        case .unknown: return .default
        }
    }

    var navigationBarStyle: UIBarStyle {
        switch self {
        case .dark: return .default
        case .light: return .black
        case .unknown: return .default
        }
    }

}

// MARK: - GetDealQuery + Model Protocols

extension GetDealQuery.Data.GetDeal.Item: ItemType {}

extension GetDealQuery.Data.GetDeal.Launch: LaunchType {}

extension GetDealQuery.Data.GetDeal.PurchaseQuantity: PurchaseQuantityType {}

extension GetDealQuery.Data.GetDeal.Story: StoryType {}

extension GetDealQuery.Data.GetDeal.Theme: ThemeType {}

extension GetDealQuery.Data.GetDeal.Topic: TopicType {}

// MARK: - ListDealsForPeriodQuery + Model Protocols

extension ListDealsForPeriodQuery.Data.ListDealsForPeriod.Theme: ThemeType {}
