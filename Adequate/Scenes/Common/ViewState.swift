//
//  ViewState.swift
//  Adequate
//
//  Created by Mathew Gacy on 9/10/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

//import Foundation

enum ViewState<Element> {
    case loading
    case result(Element)
    case empty
    case error(Error)
}

protocol ViewStateRenderable: class {
    //associatedtype ResultType
    //func render()
    //func render(_: ViewState<MehResponse>)
}

