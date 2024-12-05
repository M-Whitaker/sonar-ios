//
//  SonarQubeClientTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 05/12/2024.
//

import Cuckoo
import Foundation

@testable import SonariOS
import XCTest

final class SonarQubeClientTests: XCTestCase {
    func test_retrieveIssues_ShouldReturnListOfOneIssue() async {
        let classUnderTest = await SonarQubeClient(sonarHttpClient: MockSonarHttpClient())

        let issues = try? await classUnderTest.retrieveIssues(projectKey: "")
        XCTAssertEqual(issues?.count, 1)
    }

    func test_retrieveProjects_ShouldReturnListOfProjectResponseFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: any(), path: any(), type: any())).thenReturn(ProjectListResponse(items: [Project(key: "my-key", name: "Some Name")]))
        }

        let classUnderTest = await SonarQubeClient(sonarHttpClient: sonarHttpClient)

        let projectListResponse = try? await classUnderTest.retrieveProjects(page: Page())
        XCTAssertEqual(projectListResponse?.items.count, 1)
        XCTAssertEqual(projectListResponse?.items[0].key, "my-key")
        XCTAssertEqual(projectListResponse?.items[0].name, "Some Name")
    }

    func test_retrieveProjectStatusFor_ShouldReturnProjectStatusFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: any(), path: any(), type: any())).thenReturn(ProjectStatus(status: "PASS", newRatings: ProjectStatus.NewRatings(conditions: []), periods: []))
        }

        let classUnderTest = await SonarQubeClient(sonarHttpClient: sonarHttpClient)

        let projectStatus = try? await classUnderTest.retrieveProjectStatusFor(projectKey: "")
        XCTAssertEqual(projectStatus?.status, "PASS")
    }
}
