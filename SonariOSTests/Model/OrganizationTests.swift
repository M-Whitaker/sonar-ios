//
//  OrganizationTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 09/09/2024.
//

@testable import SonariOS
import XCTest

final class OrganizationTests: XCTestCase {
    func testShouldMapKeyToId() {
        let classUnderTest = Organization(key: "my-key")
        XCTAssertEqual(classUnderTest.id, "my-key")
    }
}
