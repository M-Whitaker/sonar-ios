//
//  IssueTests.swift
//  SonariOS
//
//  Created by Matt Whitaker on 08/12/2024.
//

@testable import SonariOS
import XCTest

final class IssueTests: XCTestCase {
    func testShouldMapKeyToId() {
        let classUnderTest = Issue(key: "my-key", rule: "rule:12345", severity: "HIGH", component: "my-project")
        XCTAssertEqual(classUnderTest.id, "my-key")
    }
}
