//
//  AdequateUITests.swift
//  AdequateUITests
//
//  Created by Mathew Gacy on 6/20/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import XCTest

// swiftlint:disable force_try
class AdequateUITests: XCTestCase {

    var app: XCUIApplication!

    let apiStub = MehSyncAPIStub()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments += ["ENABLE-UI-TESTING"]

        apiStub.stubGraphQL()
        try! apiStub.server.start(9080)

        // Setup fastlane snapshots
        setupSnapshot(app)

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        apiStub.server.stop()
    }

    func testLightMode() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        snapshot(.deal)

        let elementsQuery = app.scrollViews.otherElements

        let adequateDealviewNavigationBar: XCUIElement
        let storySnapshotName: SnapshotName
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            adequateDealviewNavigationBar = elementsQuery.navigationBars["Adequate.DealView"]
            storySnapshotName = .storyPhone
        case .pad:
            adequateDealviewNavigationBar = elementsQuery.navigationBars["Adequate.SplitView"]
            storySnapshotName = .storyPad
        default:
            XCTFail("Error: unable to handle userInterfaceIdiom: \(UIDevice.current.userInterfaceIdiom)")
            fatalError("meh")
        }

        // Show Story
        adequateDealviewNavigationBar.buttons[L10n.Accessibility.storyButton].tap()
        snapshot(storySnapshotName)

        // Back to Deal
        elementsQuery.navigationBars["Story"].buttons[L10n.Accessibility.leftChevronButton].tap()

        // Show History
        adequateDealviewNavigationBar.buttons[L10n.Accessibility.historyButton].tap()
        snapshot(.history)

        // Show Settings
        //elementsQuery.navigationBars["History"].buttons["SettingsNavBar"].tap()
        //snapshot("04Settings")

        // Dismiss Settings
        //app.navigationBars["Settings"].buttons["Done"].tap()

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

        if case .phone = UIDevice.current.userInterfaceIdiom {
            todaySnapshot(.widgets)
        }
    }

    func testDarkMode() {
        snapshot(.darkMode)
    }

}

// MARK: - Snapshot+Helpers
extension Snapshot {

    // Based on: https://github.com/fastlane/fastlane/issues/17039#issuecomment-713145839
    open class func todaySnapshot(_ name: String) {
        // https://stackoverflow.com/a/39107876/4472195
        XCUIDevice.shared.press(.home)

        NSLog("snapshot: \(name)") // more information about this, check out https://docs.fastlane.tools/actions/snapshot/#how-does-it-work

        if Snapshot.waitForAnimations {
            sleep(3)
        }

        guard self.app != nil else {
            NSLog("XCUIApplication is not set. Please call setupSnapshot(app) before snapshot().")
            return
        }

        let screenshot = XCUIScreen.main.screenshot()

        let image = XCUIDevice.shared.orientation.isLandscape ?  fixLandscapeOrientation(image: screenshot.image) : screenshot.image

        guard var simulator = ProcessInfo().environment["SIMULATOR_DEVICE_NAME"], let screenshotsDir = screenshotsDirectory else { return }

        do {
            let regex = try NSRegularExpression(pattern: "Clone [0-9]+ of ")
            let range = NSRange(location: 0, length: simulator.count)
            simulator = regex.stringByReplacingMatches(in: simulator, range: range, withTemplate: "")

            let path = screenshotsDir.appendingPathComponent("\(simulator)-\(name).png")
            //try screenshot.pngRepresentation.write(to: path)
            try image.pngData()?.write(to: path, options: .atomic)
        } catch let error {
            NSLog("Problem writing screenshot: \(name) to \(screenshotsDir)/\(simulator)-\(name).png")
            NSLog(error.localizedDescription)
        }
    }
}

// MARK: - Types
extension AdequateUITests {

    enum SnapshotName: String {
        case deal = "01Deal"
        case notifications = "02Notifications"
        case history = "03History"
        case storyPhone = "04StoryPhone"
        case storyPad = "04StoryPad"
        case darkMode = "05DarkMode"
        case widgets = "06Widgets"
    }
}

/// - Parameters:
///   - name: The name of the snapshot
///   - timeout: Amount of seconds to wait until the network loading indicator disappears. Pass `0` if you don't want to wait.
func snapshot(_ name: AdequateUITests.SnapshotName, timeWaitingForIdle timeout: TimeInterval = 20) {
    Snapshot.snapshot(name.rawValue, timeWaitingForIdle: timeout)
}

/// - Parameters:
///   - name: The name of the snapshot
func todaySnapshot(_ name: AdequateUITests.SnapshotName) {
    Snapshot.todaySnapshot(name.rawValue)
}
