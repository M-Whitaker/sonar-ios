//
//  UITestStartup.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/09/2024.
//

import HTTPTypes
import HTTPTypesFoundation
import XCTest

class UITestStartup {
    private static var instance: UITestStartup?

    var apiKey = ""

    private init() {}

    public static func getInstance() -> UITestStartup {
        if instance == nil {
            instance = UITestStartup()
        }

        XCTAssertNotNil(instance)
        return instance!
    }

    public func createApiKey() async throws {
        if apiKey.isEmpty {
            var request = HTTPRequest(method: .post, scheme: "http", authority: "localhost:9000", path: "/api/user_tokens/generate?name=ui-tests")
            request.headerFields[.accept] = "application/json"
            request.headerFields[.userAgent] = "SonariOSUITests"
            request.headerFields[.authorization] = buildAuth()

            let (responseBody, response) = try await URLSession.shared.data(for: request)
            XCTAssertEqual(response.status, 200)
            let tokens = try JSONDecoder().decode(APIKeyResponse.self, from: responseBody)
            apiKey = tokens.token
        }
    }

    private func buildAuth() -> String {
        let loginString = "admin:admin"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return "Basic \(loginData.base64EncodedString())"
    }

    struct APIKeyResponse: Codable {
        let token: String
    }
}
