//
//  ContentViewModelTests.swift
//  ContentViewModelTests
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Cuckoo
@testable import SonariOS
import XCTest

import Factory

final class ContentViewModelTests: XCTestCase {
    func test_GetProjects_ShouldRetrieveProjectListFromSonarClient() throws {
        let mock = MockSonarClient()
        stub(mock) { stub in
            when(stub.retrieveProjects()).then { () in
                print("This is a stub message")
                return [Project(id: 15)]
            }
        }
        Container.shared.sonarClient.register { mock }

        let classUnderTest = ContentViewModel()

        let expectedProjects = [Project(id: 15)]
        XCTAssertEqual(expectedProjects, classUnderTest.getProjects())
    }
}
