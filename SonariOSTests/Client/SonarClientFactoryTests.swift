//
//  SonarClientFactoryTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 11/09/2024.
//

import Foundation

@testable import SonariOS
import XCTest

final class SonarClientFactoryTests: XCTestCase {
    func test_Current_ShouldReturnSonarCloudClientWhenProfileUserDefaultsTypeIsSonarCloud() {
        let classUnderTest = SonarClientFactory()

        Preferences.standard.profiles = [SonarUserDefaultsWrapper(userDefaults: SonarQubeUserDefaults(id: "", name: "", apiKey: "", baseUrl: "")), SonarUserDefaultsWrapper(userDefaults: SonarCloudUserDefaults(id: "", name: "", apiKey: ""))]
        Preferences.standard.currentProfileIdx = 1

        XCTAssertTrue(object_getClass(classUnderTest.current) === object_getClass(SonarCloudClient()), "Is not instance of SonarCloudClient")
    }

    func test_Current_ShouldReturnSonarQubeClientWhenProfileUserDefaultsTypeIsSonarQube() {
        let classUnderTest = SonarClientFactory()

        Preferences.standard.profiles = [SonarUserDefaultsWrapper(userDefaults: SonarQubeUserDefaults(id: "", name: "", apiKey: "", baseUrl: ""))]
        Preferences.standard.currentProfileIdx = 0

        XCTAssertTrue(object_getClass(classUnderTest.current) === object_getClass(SonarQubeClient()), "Is not instance of SonarQubeClient")
    }
}
