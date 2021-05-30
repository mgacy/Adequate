import Combine
import XCTest
@testable import CurrentDealManager

final class CurrentDealManagerTests: XCTestCase {
    typealias Constants = CurrentDealManager.Constants

    var cancellables: Set<AnyCancellable>!

    var sut: CurrentDealManager!

    var session: URLSession!

    var containerURL: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.groupID)!
    }

    var dealURL: URL {
        containerURL.appendingPathComponent(Constants.dealLocation)
    }

    var imageURL: URL {
        containerURL.appendingPathComponent(Constants.imageLocation)
    }

    // MARK: - Configuration

    override func setUpWithError() throws {
        cancellables = []
        let session = Self.makeSession()
        self.session = session
        sut = CurrentDealManager(session: session)
    }

    override func tearDownWithError() throws {
        URLProtocolMock.testResponses = [:]
        session = nil
        sut = nil

        if FileManager.default.fileExists(atPath: dealURL.path) {
            try FileManager.default.removeItem(at: dealURL)
        }
        if FileManager.default.fileExists(atPath: imageURL.path) {
            try FileManager.default.removeItem(at: imageURL)
        }
    }
}

// MARK: - A
extension CurrentDealManagerTests {

    func testSave() throws {
        let imageSize: CGSize = CGSize(width: 600, height: 600)
        let imageData = UIColor.systemBlue.pngData(imageSize)
        let currentDeal: CurrentDeal = .testDeal

        URLProtocolMock.testResponses = [
            currentDeal.imageURL: .success(imageData)
        ]

        _ = try await(sut.save(currentDeal: currentDeal))

        // CurrentDeal
        let savedData = try Data(contentsOf: dealURL)
        let savedDeal = try JSONDecoder().decode(CurrentDeal.self, from: savedData)
        XCTAssertEqual(currentDeal, savedDeal)

        // Image ...
        let savedImageData = try Data(contentsOf: imageURL)
        let savedImage = UIImage(data: savedImageData)
        XCTAssertNotNil(savedImage)

        let expectedImageData = UIImage(data: imageData)?.scaledPngData(to: Constants.maxImageSize)
        XCTAssertEqual(savedImageData, expectedImageData)
    }

    func testSaveWithOverwrite() throws {
        let imageSize: CGSize = CGSize(width: 600, height: 600)
        let firstDeal: CurrentDeal = .testDeal
        let firstImageData = UIColor.systemBlue.pngData(imageSize)

        let secondDeal: CurrentDeal = .init(id: "zzzzzzzzzzzzzzzzzz", title: "Another Deal",
                                            imageURL: .anotherDeal, minPrice: 25, maxPrice: nil,
                                            launchStatus: nil)
        let secondImageData = UIColor.red.pngData(imageSize)

        URLProtocolMock.testResponses = [
            firstDeal.imageURL: .success(firstImageData),
            secondDeal.imageURL: .success(secondImageData)
        ]

        try [firstDeal, secondDeal].forEach { deal in
            _ = try await(sut.save(currentDeal: deal))
        }

        // CurrentDeal
        let savedData = try Data(contentsOf: dealURL)
        let savedDeal = try JSONDecoder().decode(CurrentDeal.self, from: savedData)
        XCTAssertEqual(savedDeal, secondDeal)

        // Image
        let savedImageData = try Data(contentsOf: imageURL)
        let expectedImageData = UIImage(data: secondImageData)?.scaledPngData(to: Constants.maxImageSize)
        XCTAssertNotNil(savedImageData)
        XCTAssertEqual(savedImageData, expectedImageData)
    }

    func testSaveWithNetworkError() throws {
        let currentDeal: CurrentDeal = .testDeal
        let networkError = URLError(.unknown, userInfo: [:])

        URLProtocolMock.testResponses = [
            currentDeal.imageURL: .failure(networkError)
        ]

        // Test
        let error = try awaitError(sut.save(currentDeal: currentDeal))
        let expectedError = CurrentDealManagerError.network(error: networkError)
        XCTAssertEqual(expectedError.localizedDescription, error.localizedDescription)
    }

    func testReadCurrentDeal() throws {
        let currentDeal: CurrentDeal = .testDeal
        let data = try JSONEncoder().encode(currentDeal)
        try data.write(to: dealURL)

        // Test
        let result = sut.readDeal()
        XCTAssertNotNil(result)
        XCTAssertEqual(currentDeal, result)
    }

    func testReadImage() throws {
        let imageSize = CGSize(width: 150, height: 150)
        let testImage = UIColor.systemBlue.image(imageSize)
        let imageData = testImage.pngData()
        try imageData?.write(to: imageURL)

        let result = sut.readImage()
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.pngData(), imageData)
    }
}

// MARK: - Support
extension CurrentDealManagerTests {

    static func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: config)
    }
}
