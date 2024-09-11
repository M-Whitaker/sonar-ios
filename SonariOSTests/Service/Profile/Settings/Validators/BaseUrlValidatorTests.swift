//
//  BaseUrlValidatorTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

@testable import SonariOS
import XCTest

final class BaseUrlValidatorTests: XCTestCase {
    let classUnderTest = BaseUrlValidator()

    func test_Validate_ShouldReturnFalseWhenInvalidValueSupplied() {
        let testCases = [
            "",
            " ",
            "   l",
            "l   ",
            "http://localhost:1234",
            "https://sonar.example.com",
        ]
        for input in testCases {
            XCTContext.runActivity(named: "Testing invalid input: \(input)") { _ in
                let userDefaults = SonarQubeUserDefaults(id: "", name: "", apiKey: "", baseUrl: input)
                XCTAssertFalse(classUnderTest.validate(userDefaults: userDefaults), "\(input) returned as true")
            }
        }
    }

    func test_Validate_ShouldReturnTrueWhenInvalidValueSupplied() {
        let testCases = [
            "localhost",
            "localhost:1234",
            "sonar.example.com",
            "sonar.example.com:5678",
        ]
        for input in testCases {
            XCTContext.runActivity(named: "Testing valid input: \(input)") { _ in
                let userDefaults = SonarQubeUserDefaults(id: "", name: "", apiKey: "", baseUrl: input)
                XCTAssertTrue(classUnderTest.validate(userDefaults: userDefaults), "\(input) returned as false")
            }
        }
    }
}
