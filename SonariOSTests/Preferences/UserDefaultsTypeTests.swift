//
//  UserDefaultsTypeTests.swift
//  SonariOS
//
//  Created by Matt Whitaker on 06/10/2024.
//
@testable import SonariOS
import XCTest

final class UserDefaultsTypeTests: XCTestCase {
    func test_Description() {
        XCTAssertEqual(UserDefaultsType.sonarCloud.description, "Sonar Cloud")
        XCTAssertEqual(UserDefaultsType.sonarQube.description, "Sonar Qube")
    }
}
