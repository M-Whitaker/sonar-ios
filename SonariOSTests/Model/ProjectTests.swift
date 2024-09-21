//
//  ProjectTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 09/09/2024.
//

@testable import SonariOS
import XCTest

final class ProjectTests: XCTestCase {
    func testShouldMapKeyToId() {
        let classUnderTest = Project(key: "my-key", name: "", organization: "")
        XCTAssertEqual(classUnderTest.id, "my-key")
    }
}
