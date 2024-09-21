//
//  ArrayUtilsTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 12/09/2024.
//

@testable import SonariOS
import XCTest

final class ArrayUtilsTests: XCTestCase {
    func test_Find_ShouldGetWhenExists() {
        let strs = ["first_element", "second_element", "third_element"]

        let optional = strs.find(at: 1)

        XCTAssertNotNil(optional)
        XCTAssertEqual("second_element", optional)
    }

    func test_Find_ShouldReturnNilWhenNotExists() {
        let strs = ["first_element"]

        let optional = strs.find(at: 1)

        XCTAssertNil(optional)
    }
}
