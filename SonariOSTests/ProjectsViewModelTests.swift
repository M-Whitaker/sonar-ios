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
    func test_GetProjects_ShouldRetrieveProjectListFromSonarClient() async throws {
        let mock = await MockSonarCloudClient()
        stub(mock) { stub in
            when(stub.retrieveProjects()).then { () in
                print("This is a stub message")
                return APIListResponse(paging: APIListResponse.Page(pageIndex: 1, pageSize: 2, total: 3), components: [Project(key: "my-project-1")])
            }
        }
        Container.shared.sonarClient.register { mock }

        let classUnderTest = ProjectsViewModel()

        let expectedProjects = [Project(key: "my-project-1")]
        let actualProjects = await classUnderTest.getProjects()
        XCTAssertEqual(expectedProjects, actualProjects)
    }
}
