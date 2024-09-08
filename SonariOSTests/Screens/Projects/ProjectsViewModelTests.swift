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
        let sonarClient = await MockSonarCloudClient()
        stub(sonarClient) { stub in
            when(stub.retrieveProjects(page: any())).thenReturn(ProjectListResponse(items: [Project(key: "my-project-1")]))
        }

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = ProjectsViewModel()

        let expectedProjects = [Project(key: "my-project-1")]
        await classUnderTest.getProjects()
        XCTAssertEqual(classUnderTest.state, .loaded(expectedProjects))
    }
}
