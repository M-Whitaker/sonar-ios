//
//  SonariOSUITests.swift
//  SonariOSUITests
//
//  Created by Matt Whitaker on 17/08/2024.
//

import XCTest

final class SonariOSUITests: XCTestCase {
    var uiTestStartup: UITestStartup?

    override func setUp() async throws {
        uiTestStartup = UITestStartup.getInstance()
        try await uiTestStartup!.createApiKey()
        continueAfterFailure = false
    }

    func testCreateProfileOnFirstLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let usernameTextField = app.textFields["Name"]
        usernameTextField.tap()
        usernameTextField.typeText("Hello SonarQube")

        let accountTypeButton = app.buttons["Account Type, Sonar Cloud"]
        accountTypeButton.tap()
        app.buttons["Sonar Qube"].tap()

        let apiKeyTextField = app.textFields["API Key"]
        apiKeyTextField.tap()
        apiKeyTextField.typeText(uiTestStartup!.apiKey)

        let baseUrlField = app.textFields["Base URL"]
        baseUrlField.tap()
        baseUrlField.typeText("localhost:9000")

        app.navigationBars["Create Profile"].buttons["Add"].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(app.staticTexts["Projects"].exists)
        XCTAssert(app.staticTexts["Example of basic Maven project"].waitForExistence(timeout: 5))
    }
}
