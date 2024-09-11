//
//  NameValidatorTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

@testable import SonariOS
import XCTest

final class NameValidatorTests: XCTestCase {
    let classUnderTest = NameValidator()

    func test_Validate_ShouldReturnFalseWhenInvalidValueSupplied() {
        let testCases = [
            "",
        ]
        for input in testCases {
            XCTContext.runActivity(named: "Testing invalid input: \(input)") { _ in
                let userDefaults = SonarUserDefaults(id: "", name: input, type: .sonarQube, apiKey: "")
                XCTAssertFalse(classUnderTest.validate(userDefaults: userDefaults), "\(input) returned as true")
            }
        }
    }

    func test_Validate_ShouldReturnTrueWhenInvalidValueSupplied() {
        let testCases = [
            "SonarQube",
            "Sonar Qube",
        ]
        for input in testCases {
            XCTContext.runActivity(named: "Testing valid input: \(input)") { _ in
                let userDefaults = SonarUserDefaults(id: "", name: input, type: .sonarQube, apiKey: "")
                XCTAssertTrue(classUnderTest.validate(userDefaults: userDefaults), "\(input) returned as false")
            }
        }
    }
}
