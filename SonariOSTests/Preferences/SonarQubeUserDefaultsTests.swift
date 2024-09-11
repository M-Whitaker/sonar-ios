//
//  SonarQubeUserDefaultsTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

@testable import SonariOS
import XCTest

final class SonarQubeUserDefaultsTests: XCTestCase {
    func test_Encode_Should() throws {
        let expectedBody = """
        {
          "apiKey" : "pky_expc_12345",
          "baseUrl" : "sonar.expected.example.com",
          "id" : "some-expected-id",
          "name" : "My Expected Name Here",
          "type" : {
            "sonarQube" : {

            }
          }
        }
        """
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let encoded = try encoder.encode(SonarQubeUserDefaults(id: "some-expected-id", name: "My Expected Name Here", apiKey: "pky_expc_12345", baseUrl: "sonar.expected.example.com"))
        XCTAssertEqual(String(data: encoded, encoding: .utf8)!, expectedBody)
    }

    func test_Decode_Should() throws {
        let body = """
        {
          "id": "some-id",
          "name": "My Name Here",
          "type": {
            "sonarQube": {}
          },
          "apiKey": "pky_12345",
          "baseUrl": "localhost:5000"
        }
        """
        let decoded = try JSONDecoder().decode(SonarQubeUserDefaults.self, from: body.data(using: .utf8)!)

        let expected = SonarQubeUserDefaults(id: "some-id", name: "My Name Here", apiKey: "pky_12345", baseUrl: "localhost:5000")
        XCTAssertEqual(decoded.id, expected.id)
        XCTAssertEqual(decoded.name, expected.name)
        XCTAssertEqual(decoded.apiKey, expected.apiKey)
        XCTAssertEqual(decoded.baseUrl, expected.baseUrl)
    }
}
