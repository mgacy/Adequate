//
//  AdequateUITests.swift
//  AdequateUITests
//
//  Created by Mathew Gacy on 6/20/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import XCTest

class AdequateUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()

        // Setup fastlane snapshots
        setupSnapshot(app)

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        // TODO: wait for loading to finish?
        snapshot("01Deal")

        let elementsQuery = app.scrollViews.otherElements
        let adequateDealviewNavigationBar = elementsQuery.navigationBars["Adequate.DealView"]

        // Show Story
        adequateDealviewNavigationBar.buttons[L10n.Accessibility.storyButton].tap()
        snapshot("02Story")

        // Back to Deal
        elementsQuery.navigationBars["Story"].buttons["LeftChevronNavBar"].tap()

        // Show History
        adequateDealviewNavigationBar.buttons[L10n.Accessibility.historyButton].tap()
        snapshot("03History")

        // Show Settings
        elementsQuery.navigationBars["History"].buttons["SettingsNavBar"].tap()
        snapshot("04Settings")

        // Dismiss Settings
        app.navigationBars["Settings"].buttons["Done"].tap()

        // Show HistoryDetail
        //elementsQuery.tables.staticTexts["5-Pack: GenTek 9H Ceramic Liquid Screen Protector"].tap()
        //elementsQuery.tables.staticTexts["iJoy Mini Projector Set with Screen and Speakers"].tap()

        // Show FullscreenImage
        //elementsQuery.collectionViews.cells.children(matching: .other).element.tap()

        // Dismiss FullscreenImage

        // Dismiss HistoryDetail
        //app.navigationBars["Adequate.HistoryDetailView"].buttons["CloseNavBar"].tap()

        // ...

        //app.swipeLeft() // This results in swiping on the paged image view
    }

}
