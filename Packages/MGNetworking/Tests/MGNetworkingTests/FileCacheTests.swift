//
//  FileCacheTests.swift
//  
//
//  Created by Mathew Gacy on 1/1/21.
//

import XCTest
@testable import MGNetworking

// swiftlint:disable identifier_name

class FileCacheTests: XCTestCase {

    var fileLocation: FileLocation!

    var fileManager: FileManager {
        .default
    }

    var cacheLocation: URL! {
        fileLocation.containerURL
    }

    // MARK: - A

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fileLocation = Self.makeFileLocation()
        XCTAssertNotNil(fileLocation.containerURL)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        if let location = fileLocation.containerURL {
            guard fileManager.fileExists(atPath: location.path) else {
                return
            }

            try fileManager.removeItem(at: location)
            fileLocation = nil
        }
    }
}

// TODO: test ImageCoder

// MARK: - Write
extension FileCacheTests {

    func testWrite() throws {
        // Setup
        let imageData = Self.makeTestPngData()
        let imageToSave = UIImage(data: imageData)!

        let imageKey = Constants.defaultKey
        let cacheLocation = fileLocation!.containerURL!
        let expectedCachedFileLocation = cacheLocation.appendingPathComponent(imageKey.lastPathComponent)

        // Test
        let sut = FileCache(fileLocation: fileLocation, coder: Coder<Any>.makeImageCoder())
        sut.insert(imageToSave, for: imageKey)

        let cachedFileExists = fileManager.fileExists(atPath: expectedCachedFileLocation.path)
        XCTAssert(cachedFileExists, "Cached file missing")

        //let cachedData = try Data(contentsOf: expectedCachedFileLocation)
        //let image = UIImage(data: cachedData)
        let image = UIImage(contentsOfFile: expectedCachedFileLocation.path)
        XCTAssertNotNil(image)
        XCTAssertEqual(imageToSave.pngData(), image?.pngData())
    }
}

// MARK: - Read
extension FileCacheTests {

    func testRead() throws {
        // Setup
        let imageData = Self.makeTestPngData()
        let imageKey = Constants.defaultKey

        let cacheLocation = fileLocation!.containerURL!
        let expectedCachedFileLocation = cacheLocation.appendingPathComponent(imageKey.lastPathComponent)

        try fileManager.createDirectory(at: cacheLocation, withIntermediateDirectories: true, attributes: nil)
        try imageData.write(to: expectedCachedFileLocation)

        // Test
        let sut = FileCache(fileLocation: fileLocation, coder: Coder<Any>.makeImageCoder())
        let result = sut.value(for: imageKey)

        XCTAssertNotNil(result)
        XCTAssertEqual(imageData, result?.pngData())
    }
}

// MARK: - Update
extension FileCacheTests {

    func testOverwrite() throws {
        // Setup
        let firstImage = try Self.makeTestImage()
        let imageKey = Constants.defaultKey
        let cacheLocation = fileLocation!.containerURL!
        let expectedCachedFileLocation = cacheLocation.appendingPathComponent(imageKey.lastPathComponent)

        let secondImage = try Self.makeTestImage(color: .red, size: CGSize(width: 350, height: 350))

        // Test
        let sut = FileCache(fileLocation: fileLocation, coder: Coder<Any>.makeImageCoder())
        sut.insert(firstImage, for: imageKey)
        sut.insert(secondImage, for: imageKey)

        let cachedData = try Data(contentsOf: expectedCachedFileLocation)
        let cachedImage = UIImage(data: cachedData)
        //let cachedImage = UIImage(contentsOfFile: expectedCachedFileLocation?.path)

        XCTAssertNotNil(cachedImage)
        XCTAssertNotEqual(firstImage.pngData(), cachedData, "Failed to overwrite")
        XCTAssertEqual(secondImage.pngData(), cachedData)
    }
}

// MARK: - Delete
extension FileCacheTests {

    func testDelete() throws {
        let key = Constants.defaultKey
        let cacheLocation = fileLocation!.containerURL!
        let expectedCachedFileLocation = cacheLocation.appendingPathComponent(key.lastPathComponent)

        try fileManager.createDirectory(at: cacheLocation, withIntermediateDirectories: true, attributes: nil)
        try Self.makeTestPngData().write(to: expectedCachedFileLocation)

        // Test
        let sut = FileCache(fileLocation: fileLocation!, coder: Coder<Any>.makeImageCoder())
        sut.removeValue(for: key)

        let fileExists = fileManager.fileExists(atPath: expectedCachedFileLocation.path)
        XCTAssertFalse(fileExists)
    }

    func testDeleteAll() throws {
        let fileCount: Int = 10
        let cacheLocation = fileLocation!.containerURL!

        // Write files
        try fileManager.createDirectory(at: cacheLocation, withIntermediateDirectories: true)
        for i in 0...fileCount {
            let fileLocation = cacheLocation.appendingPathComponent("\(i).txt")
            let data = "This is a test: \(i)".data(using: .utf8)!

            fileManager.createFile(atPath: fileLocation.path, contents: data)
            guard fileManager.fileExists(atPath: fileLocation.path) else {
                fatalError("Error writing data")
            }
        }

        let initialContents = try fileManager.contentsOfDirectory(atPath: cacheLocation.path)
        XCTAssertFalse(initialContents.isEmpty)

        // Test
        let sut = FileCache(fileLocation: fileLocation!, coder: Coder<Any>.makeImageCoder())
        sut.removeAll()

        // TODO: is expected behavior that cache directory is empty or that it doesn't exist?
        let directoryExists = fileManager.fileExists(atPath: cacheLocation.path)
        XCTAssertFalse(directoryExists)
        //let cacheContents = try fileManager.contentsOfDirectory(atPath: cacheLocation.path)
        //XCTAssertTrue(cacheContents.isEmpty)
    }

    func testMaxFileCountRespected() throws {
        let maxFileCount = 5
        let imageSize = CGSize(width: 600, height: 600)
        let cacheLocation = fileLocation!.containerURL!

        let sut = FileCache(fileLocation: fileLocation!, coder: Coder<Any>.makeImageCoder(), maxFileCount: maxFileCount)

        for i in 0...(maxFileCount * 2) {
            let value = UIColor(i: i).image(imageSize)
            let urlString = Constants.mehImageBaseString + String(i) + ".png"
            let key = URL(string: urlString)!

            sut.insert(value, for: key)
        }

        // FIXME: remove `maxFileCount` adjustment
        let cacheContents = try fileManager.contentsOfDirectory(atPath: cacheLocation.path)
        XCTAssertEqual(cacheContents.count, maxFileCount + 1)
    }

    func testCleanup() throws {
        let maxFileCount = 5
        let totalImageCount = 255
        let imageSize = CGSize(width: 600, height: 600)

        let sut = FileCache(fileLocation: fileLocation!, coder: Coder<Any>.makeImageCoder())

        // Files we expect to be removed
        for i in 0...totalImageCount - maxFileCount {
            let value = UIColor(i: i).image(imageSize)
            let urlString = Constants.mehImageBaseString + String(i) + ".png"
            let key = URL(string: urlString)!

            sut.insert(value, for: key)
        }

        // Files we expect to find in cache
        var expected = [URL: UIImage]()
        for i in totalImageCount - maxFileCount + 1...totalImageCount {
            let value = UIColor(i: i).image(imageSize)
            let urlString = Constants.mehImageBaseString + String(i) + ".png"
            let key = URL(string: urlString)!
            expected[key] = value

            sut.insert(value, for: key)
        }

        // FIXME: remove `maxFileCount` adjustment
        // Verify only expected number of images remain
        let cacheContents = try fileManager.contentsOfDirectory(atPath: cacheLocation.path)
        XCTAssertEqual(cacheContents.count, maxFileCount + 1)

        // Verify they are the images we expect
        expected.forEach { key, value in
            // Verify cached file exists
            let cachedLocation = cacheLocation.appendingPathComponent(key.lastPathComponent)
            let cachedImage = UIImage(contentsOfFile: cachedLocation.path)
            XCTAssertNotNil(cachedImage)

            // Verify cached image matches original
            XCTAssertEqual(value.pngData(), cachedImage?.pngData())
        }
    }
}

// MARK: - Support
extension FileCacheTests {

    static func makeFileLocation() -> FileLocation {
        let pathComponent = "tests"
        return UserLocation.temp(pathComponent)
    }

    static func makeTestPngData(color: UIColor = .blue, size: CGSize = Constants.defaultImageSize) -> Data {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.pngData { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }

    static func makeTestImage(color: UIColor = .blue, size: CGSize = Constants.defaultImageSize) throws -> UIImage {
        return try UIImage(data: Self.makeTestPngData(color: color, size: size)).unwrap()
    }
}

// MARK: - Types
// swiftlint:disable:next private_over_fileprivate
fileprivate typealias Constants = FileCacheConstants

enum FileCacheConstants {
    // swiftlint:disable:next line_length
    static var mehImageBaseString = "https://d2b8wt72ktn9a2.cloudfront.net/mediocre/image/upload/c_pad,f_auto,h_600,q_auto,w_600/"

    static var mehImageName1 = "j1cdevi8xm7iglxyy8qm.png"

    static var defaultKey: URL {
        return URL(string: Self.mehImageBaseString + Self.mehImageName1)!
    }

    static var defaultImageSize = CGSize(width: 600, height: 600)
}
