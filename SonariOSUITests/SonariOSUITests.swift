//
//  SonariOSUITests.swift
//  SonariOSUITests
//
//  Created by Matt Whitaker on 17/08/2024.
//

import XCTest

final class SonariOSUITests: XCTestCase {

    override func setUpWithError() throws {
        
        continueAfterFailure = false
    }

    func testCreateProfileOnFirstLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
