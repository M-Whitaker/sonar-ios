//
//  ProjectsViewModelTests.swift
//  ContentViewModelTests
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Cuckoo
@testable import SonariOS
import XCTest

import Factory

final class ProjectsViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_GetProjects_ShouldRetrieveProjectListFromSonarClient() async throws {
        // TODO: Fix mocks actually calling prod objects
        let sonarClient = await MockSonarCloudClient()
        stub(sonarClient) { stub in
            when(stub.retrieveProjects(page: any())).then { _ in
                print("This is a stub message")
                return ProjectListResponse(items: [Project(key: "my-project-1")])
            }
        }

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).then { () in
                print("This is the mock factory")
                return sonarClient
            }
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = ProjectsViewModel()

        let expectedProjects = [Project(key: "my-project-1")]
        await classUnderTest.getProjects()
        XCTAssertEqual(classUnderTest.state, .loaded(expectedProjects))
    }
}
