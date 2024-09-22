//
//  SonariOSUITests.swift
//  SonariOSUITests
//
//  Created by Matt Whitaker on 17/08/2024.
//

import HTTPTypes
import HTTPTypesFoundation
import XCTest

struct APIKeyResponse: Codable {
    let token: String
}

final class SonariOSUITests: XCTestCase {
    private var apiKey: String = ""

    override func setUp() async throws {
        try await createApiKey()
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
        apiKeyTextField.typeText(apiKey)

        let baseUrlField = app.textFields["Base URL"]
        baseUrlField.tap()
        baseUrlField.typeText("localhost:9000")

        app.navigationBars["Create Profile"].buttons["Add"].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(app.staticTexts["Projects"].exists)
    }

    func createApiKey() async throws {
        var request = HTTPRequest(method: .post, scheme: "http", authority: "localhost:9000", path: "/api/user_tokens/generate?name=ui-tests")
        request.headerFields[.accept] = "application/json"
        request.headerFields[.userAgent] = "SonariOSUITests"
        request.headerFields[.authorization] = buildAuth()

        let (responseBody, response) = try await URLSession.shared.data(for: request)
        XCTAssertEqual(response.status, 200)
        let tokens = try JSONDecoder().decode(APIKeyResponse.self, from: responseBody)
        apiKey = tokens.token
    }

    private func buildAuth() -> String {
        let loginString = "admin:admin"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return "Basic \(loginData.base64EncodedString())"
    }
}
