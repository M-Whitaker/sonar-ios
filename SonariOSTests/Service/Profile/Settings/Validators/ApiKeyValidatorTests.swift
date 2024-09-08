//
//  ApiKeyValidatorTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

@testable import SonariOS
import XCTest

final class ApiKeyValidatorTests: XCTestCase {
    let classUnderTest = ApiKeyValidator()

    func test_Validate_ShouldReturnFalseWhenInvalidValueSupplied() {
        let testCases = [
            "",
        ]
        for input in testCases {
            XCTContext.runActivity(named: "Testing invalid input: \(input)") { _ in
                let userDefaults = SonarUserDefaults(id: "", name: "", type: .sonarQube, apiKey: input)
                XCTAssertFalse(classUnderTest.validate(userDefaults: userDefaults), "\(input) returned as true")
            }
        }
    }

    func test_Validate_ShouldReturnTrueWhenInvalidValueSupplied() {
        let testCases = [
            "abc_123",
            "sky12jwid",
        ]
        for input in testCases {
            XCTContext.runActivity(named: "Testing valid input: \(input)") { _ in
                let userDefaults = SonarUserDefaults(id: "", name: "", type: .sonarQube, apiKey: input)
                XCTAssertTrue(classUnderTest.validate(userDefaults: userDefaults), "\(input) returned as false")
            }
        }
    }
}
