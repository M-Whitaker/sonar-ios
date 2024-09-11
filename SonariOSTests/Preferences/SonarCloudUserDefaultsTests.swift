//
//  SonarCloudUserDefaultsTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

@testable import SonariOS
import XCTest

final class SonarCloudUserDefaultsTests: XCTestCase {
    func test_Encode_Should() throws {
        let expectedBody = """
        {
          "apiKey" : "pky_expc_12345",
          "id" : "some-expected-id",
          "name" : "My Expected Name Here",
          "type" : {
            "sonarCloud" : {

            }
          }
        }
        """
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let encoded = try encoder.encode(SonarCloudUserDefaults(id: "some-expected-id", name: "My Expected Name Here", apiKey: "pky_expc_12345"))
        XCTAssertEqual(String(data: encoded, encoding: .utf8)!, expectedBody)
    }

    func test_Decode_Should() throws {
        let body = """
        {
          "id": "some-id",
          "name": "My Name Here",
          "type": {
            "sonarCloud": {}
          },
          "apiKey": "pky_12345"
        }
        """
        let decoded = try JSONDecoder().decode(SonarCloudUserDefaults.self, from: body.data(using: .utf8)!)

        let expected = SonarCloudUserDefaults(id: "some-id", name: "My Name Here", apiKey: "pky_12345")
        XCTAssertEqual(decoded.id, expected.id)
        XCTAssertEqual(decoded.name, expected.name)
        XCTAssertEqual(decoded.apiKey, expected.apiKey)
    }
}
