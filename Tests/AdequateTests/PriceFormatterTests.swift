//
//  PriceFormatterTests.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/16/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import XCTest
@testable import Adequate

typealias PurchaseQuantity = Deal.PurchaseQuantity

class PriceFormatterTests: XCTestCase {

    // MARK: PurchaseQuantity

    let singlePurchaseQuantity: PurchaseQuantity = PurchaseQuantity(maximumLimit: 3, minimumLimit: 1)

    let multiplePurchaseQuantity: PurchaseQuantity = PurchaseQuantity(maximumLimit: 3, minimumLimit: 2)

    // MARK: Item Prices

    let singlePrice: [Double] = [12.0]

    let duplicatePrices: [Double] = [12.0, 12.0]

    let multiplePrices: [Double] = [12.0, 15.0, 13.0]

    // MARK: Specifications

    let standardSpecs = """
    Specs\r\n====\r\n- Product Name: Echobox Traveler \"Not So Entry Level\" Titanium Headphones\r\n- Model: T1a\r\n- Condition: New\r\n- Available in Android or iPhone styles \r\n- Colors available in Blue, White, Black, or Orange\r\n- Housing: Machined Titanium\r\n- Driver: 9.2mm \r\n- Cable: Tin Plated Line \r\n- Plug: 3.5mm Stereo\r\n- Frequency Range: 5Hz - 55kHz\r\n- Sensitivity: 96dB/mW\r\n- Mic Sensitivity: -42 / 3db\r\n- Impedance: 22 Ω \r\n- THD: < 1%\r\n- Controls: \r\n  - Volume Up \r\n  - Volume Down\r\n  - Play/Pause\r\n  - Voice Controls \r\n  - Answer/Hang Up \r\n  - Reject Incoming Call \r\n- [Video Review](https://www.youtube.com/watch?v=O1pDg3K_8SM)\r\n- [Drop Reviews](https://drop.com/buy/echobox-traveler-iem)\r\n\r\n\r\nWhat's in the Box?\r\n====\r\n- 1x Echobox Traveler \"Not So Entry Level\" Titanium Headphones\r\n- 5 Pairs of Headphone Tips  \r\n- Cloth Carry Bag \r\n\r\nPrice Comparison\r\n====\r\n[$29.97 at Amazon](https://www.amazon.com/Echobox-Traveler-Titanium-ear-Headphones/dp/B07CHVNR1J/?tag=meh0ec-20)
    """

    let specsA = """
    Specs\r\n====\r\n- Model: ODY-2017BF2\r\n- Condition: New\r\n- Flight time: Up to 12 minutes\r\n- 720p video streams via WiFi\r\n- Virtual Reality Headset holds phone for first-person flying (note: drone only has one camera so the image will not be stereoscopic 3D)\r\n- Fly by 2.4GHz remote control or app ([Android](https://play.google.com/store/apps/details?id=com.ihunuo.unity.wifi.stellar&hl=en_US) | [iOS](https://itunes.apple.com/us/app/stellar-nx-drone/id1287941127?mt=8))\r\n- Batteries: 3.7V/550mAh\r\n- Charge Time 60 Minutes\r\n- Drone remote batteries: 3x AA (not included)\r\n- Mini drone remote batteries: 4x AAA (sold separately)\r\n\r\nWhat's in the Box?\r\n====\r\n1x Stellar NX Drone\r\n1x 2.4 GHz Remote Control\r\n2x Battery\r\n1x USB Charging Cable\r\n1x Spare Blade Set\r\n1x Odyssey VR/3D Headset\r\n1x mini drone\r\n\r\nPrice Comparison\r\n====\r\n[\\$70.91 at Amazon (on \"sale\" from \\$68.08?)](https://www.amazon.com/dp/B0788WKG8Q/?tag=meh0ec-20)
    """

    let specsB = """
    "Specs\r\n====\r\n- Model: DRC-TOALLA\r\n- Condition: New \r\n- 15\"x36\"\r\n- 100% Polyester\r\n- Cools up to 30% lower than surface temperature\r\n- Cools via wicking, moisture circulation, and regulated evaporation\r\n\r\nWhat's in the Box?\r\n====\r\n3x Dr. Cool Towels\r\n\r\nPrice Comparison\r\n====\r\n[\\$29.97 (for 3) at Amazon](https://www.amazon.com/dp/B01ITZ2WDU/?tag=meh0ec-20)
    """

    let specsC = """
    Specs \r\n==== \r\n- Model: R1804 \r\n- Condition: New \r\n- Color: Silver \r\n- Blade Length: 3.468\" (88.09 mm) \r\n- Edge: Combination featuring [Veff serrations](https://www.crkt.com/veff-serrations/) \r\n- Blade Steel: 8Cr13MoV \r\n- Blade Finish: Stonewash \r\n- Blade Thickness: 0.141\" (3.58 mm) \r\n- Closed Length: 4.345\" (110.36 mm) \r\n- Weight: 3.8 oz \r\n- Handle: 6061-T6 Al \r\n- Style: Folding Knife w/Locking Liner \r\n- Sheath Material: Nylon webbing \r\n- Overall Length: 7.875\" (200.03 mm) \r\n\r\nWhat's in the Box? \r\n==== \r\n2x CRKT Ruger Go-N-Heavy Compact Knives \r\n\r\nPrice Comparison \r\n==== \r\n[\\$93.30 (for 2) at Amazon](https://www.amazon.com/dp/B01BIVZ9QY/?tag=meh0ec-20)
    """

    let specsD = """
    Specs\r\n====\r\n- Model: It's a secret\r\n- Condition: New, no retail packaging\r\n- Blades in each cartridge: 6 Blades + 1 trimmer\r\n- Blade Construction: Flow Through\r\n- Head: Pivot\r\n- Lubricating strip contains: Vitamin E, Aloe, Lavender Oil\r\n- Handle: Rubber Grip\r\n- Choose between:\r\n  - 3x 4-packs of six-blade cartridges plus one handle with cartridge\r\n  - 13x 4-packs of six-blade cartridges plus two handles with one cartridge each\r\n\r\nWhat's in the Box?\r\n====\r\n13x Six-blade Cartridges\r\n1x Handle\r\nOr\r\n54x Six-blade Cartridges\r\n2x Handles\r\n\r\nPrice Comparison\r\n====\r\n[\\$24.96 - $99.99 (for similar and compatible without handles) at Amazon](https://www.amazon.com/dp/B008O82O7C/?tag=meh0ec-20)
    """

    let specsE = """
    Specs\r\n====\r\n- Model: CT680W \r\n- Condition: New \r\n- Wattage: 1200 \r\n- Three interchangeable vessels:\r\n  - 72 oz Total Crushing Pitcher (64 oz max liquid capacity)\r\n  - 24-ounce Nutri Ninja® Cup\r\n  - 8-Cup Precision Processor\r\n- Chop, mince, grind, puree, blend, make dough, ice cream and more\r\n- Features unique pre-set programs specific to each attachment that will modify blade speeds, pulses, and run times for consistent results\r\n- Power: 1200 watts/1.6 horsepower\r\n- Rustproof and dishwasher-safe blades\r\n- 3ft cord\r\n- Dimensions: 17.2\" x 8.2\" x 7.5\" \r\n- Weight: 8.3 pounds \r\n- [Manual](https://www.ninjakitchen.com/include/pdf/manual-CT680.pdf) \r\n- [Quick Start Guide](https://www.ninjakitchen.com/include/pdf/QSG-CT680.pdf) \r\n- [Inspiration Guide](https://www.ninjakitchen.com/include/pdf/IG-CT680.pdf) \r\n\r\nWhat's in the Box?\r\n====\r\n1x 1200-Watt Motor Base with Touchscreen Display\r\n1x 72 oz. (64 oz. max liquid capacity) Total Crushing® Pitcher\r\n1x Stacked Blade Assembly\r\n1x 8-cup Precision Processor™\r\n1x Precision Processing Blade Assembly\r\n1x Dough Blade Assembly\r\n1x 24-ounce Nutri Ninja® Cup\r\n1x Spout Lid\r\n1x Pro Extractor Blades® Assembly\r\n1x 35-Recipe Cookbook\r\n\r\nPrice Comparison\r\n====\r\n[\\$199 at Walmart](https://www.walmart.com/ip/Ninja-Intelli-Sense-Kitchen-System-CT680/579166437)
    """

    // MARK: - Setup
    /*
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    */
}

// MARK: - Price Comparison Tests
extension PriceFormatterTests {

    func test_comparison_standard() throws {
        let sut = PriceFormatter()
        let expected = "$29.97 at Amazon"

        let deal = Deal.create(specifications: standardSpecs)
        let (_, actual) = try sut.parsePriceData(from: deal)
        let unwrapped = try XCTUnwrap(actual)
        XCTAssertEqual(unwrapped, expected)
    }
    /*
    func test_comparison_1() throws {
        let sut = PriceFormatter()
        let expected = """
        $70.91 at Amazon (on "sale" from $68.08?)
        """

        let deal = Deal.create(specifications: specsA)
        let (_, actual) = try sut.parsePriceData(from: deal)
        let unwrapped = try XCTUnwrap(actual)
        XCTAssertEqual(unwrapped, expected)
    }

    func test_comparison_2() throws {
        let sut = PriceFormatter()
        let expected = "$29.97 (for 3) at Amazon"

        let deal = Deal.create(specifications: specsB)
        let (_, actual) = try sut.parsePriceData(from: deal)
        let unwrapped = try XCTUnwrap(actual)
        XCTAssertEqual(unwrapped, expected)
    }

    // FIXME: this doesn't really add another different from `testFormatter_2()`
    func test_comparison_3() throws {
        let sut = PriceFormatter()
        let expected = "$93.30 (for 2) at Amazon"

        let deal = Deal.create(specifications: specsC)
        let (_, actual) = try sut.parsePriceData(from: deal)
        let unwrapped = try XCTUnwrap(actual)
        XCTAssertEqual(unwrapped, expected)
    }

    func test_comparison_4() throws {
        let sut = PriceFormatter()
        let expected = "$24.96 - $99.99 (for similar and compatible without handles) at Amazon"

        let deal = Deal.create(specifications: specsD)
        let (_, actual) = try sut.parsePriceData(from: deal)
        let unwrapped = try XCTUnwrap(actual)
        XCTAssertEqual(unwrapped, expected)
    }
    */
    func test_comparison_5() throws {
        let sut = PriceFormatter()
        let expected = "$199 at Walmart"

        let deal = Deal.create(specifications: specsE)
        let (_, actual) = try sut.parsePriceData(from: deal)
        let unwrapped = try XCTUnwrap(actual)
        XCTAssertEqual(unwrapped, expected)
    }
}

// MARK: - PriceRange Tests
extension PriceFormatterTests {

    // MARK: - Deal.purchaseQuantity: nil

    // FIXME: is this really how we want this to behave?
    func test_range_nilPurchaseQuantity_emptyItems() throws {
        let sut = PriceFormatter()
        let expected = "ERROR: missing price"

        let deal = Deal.create(items: [], purchaseQuantity: nil)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_nilPurchaseQuantity_singleItem() throws {
        let sut = PriceFormatter()
        let expected = "$12"

        let items = singlePrice.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: nil)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_nilPurchaseQuantity_duplicateItem() throws {
        let sut = PriceFormatter()
        let expected = "$12"

        let items = duplicatePrices.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: nil)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_nilPurchaseQuantity_multipleItem() throws {
        let sut = PriceFormatter()
        let expected = "$12 - $15"

        let items = multiplePrices.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: nil)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    // MARK: - PurchaseQuantity.minimumLimit: 1

    func test_range_singlePurchaseQuantity_emptyItems() throws {
        let sut = PriceFormatter()
        let expected = "ERROR: missing price"

        let deal = Deal.create(items: [], purchaseQuantity: singlePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_singlePurchaseQuantity_singleItem() throws {
        let sut = PriceFormatter()
        let expected = "$12"

        let items = singlePrice.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: singlePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_singlePurchaseQuantity_duplicateItem() throws {
        let sut = PriceFormatter()
        let expected = "$12"

        let items = duplicatePrices.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: singlePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_singlePurchaseQuantity_multipleItems() throws {
        let sut = PriceFormatter()
        let expected = "$12 - $15"

        let items = multiplePrices.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: singlePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    // MARK: - PurchaseQuantity.minimumLimit: > 1

    func test_range_multiplePurchaseQuantity_emptyItems() throws {
        let sut = PriceFormatter()
        let expected = "ERROR: missing price"

        let deal = Deal.create(items: [], purchaseQuantity: multiplePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_multiplePurchaseQuantity_singleItem() throws {
        let sut = PriceFormatter()
        let expected = "$24"

        let items = singlePrice.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: multiplePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_multiplePurchaseQuantity_duplicateItem() throws {
        let sut = PriceFormatter()
        let expected = "$24"

        let items = duplicatePrices.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: multiplePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }

    func test_range_multiplePurchaseQuantity_multipleItems() throws {
        let sut = PriceFormatter()
        let expected = "$24 - $30"

        let items = multiplePrices.map { Item.create(price: $0) }
        let deal = Deal.create(items: items, purchaseQuantity: multiplePurchaseQuantity)

        let (actual, _) = try sut.parsePriceData(from: deal)
        XCTAssertEqual(actual, expected)
    }
}
