//
//  SettingsViewModelTests.swift
//  SonariOS
//
//  Created by Matt Whitaker on 08/12/2024.
//

import Cuckoo
@testable import SonariOS
import XCTest

import Factory

final class SettingsViewModelTests: XCTestCase {
    let mockSonarHttpClient = MockSonarHttpClient()

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_retrieveUserInfo_ShouldPopulateNameAndEmailWhenSuccessful() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)

        stub(sonarClient) { stub in
            when(stub.retrieveCurrentUser()).thenReturn(User(name: "Matt Whitaker", email: "matt@example.com"))
        }

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = SettingsViewModel()
        try await classUnderTest.retrieveUserInfo()

        XCTAssertEqual(classUnderTest.name, "Matt Whitaker")
        XCTAssertEqual(classUnderTest.email, "matt@example.com")
    }
}
