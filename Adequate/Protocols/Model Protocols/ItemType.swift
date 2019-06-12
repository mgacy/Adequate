//
//  ItemType.swift
//  Adequate
//
//  Created by Mathew Gacy on 6/12/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

protocol ItemType {
    var condition: String { get }
    var id: String { get }
    var price: Int { get }
    var photo: String { get }
}
