//
//  AddProfileViewModelTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

import Cuckoo
@testable import SonariOS
import XCTest

import Factory

final class AddProfileViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_FormSubmit_ShouldValidateFormAndCreateNewProfile() {
        let classUnderTest = AddProfileViewModel()
        classUnderTest.valid = false
        classUnderTest.profiles = []

        classUnderTest.name = "The Name of the Profile"
        classUnderTest.apiKey = "key_12345"
        classUnderTest.formSubmit()

        XCTAssertTrue(classUnderTest.valid)
        XCTAssertEqual(classUnderTest.profiles.count, 1)
        XCTAssertEqual(classUnderTest.profiles[0].userDefaults.id, "SonariOS.The Name of the Profile")
        XCTAssertEqual(classUnderTest.profiles[0].userDefaults.name, "The Name of the Profile")
        XCTAssertEqual(classUnderTest.profiles[0].userDefaults.apiKey, "key_12345")
    }
}
