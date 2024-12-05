//
//  SonarCloudClientTests 2.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 05/12/2024.
//

import Cuckoo
import Foundation

@testable import SonariOS
import XCTest

final class SonarCloudClientTests: XCTestCase {
    func test_retrieveIssues_ShouldReturnListOfOneIssue() async {
        let classUnderTest = await SonarCloudClient(sonarHttpClient: MockSonarHttpClient())

        let issues = try? await classUnderTest.retrieveIssues(projectKey: "")
        XCTAssertEqual(issues?.count, 1)
    }

    func test_retrieveProjects_ShouldReturnListOfProjectResponseFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: equal(to: .get), path: equal(to: "/organizations/search?member=true"), type: any())).thenReturn(OrganizationListResponse(items: [Organization(key: "my-org")]))

            when(stub.call(baseUrl: any(), apiKey: any(), method: equal(to: .get), path: equal(to: "/components/search?organization=my-org&p=1&ps=100"), type: any())).thenReturn(ProjectListResponse(items: [Project(key: "my-key", name: "Some Name")]))
        }

        let classUnderTest = await SonarCloudClient(sonarHttpClient: sonarHttpClient)

        let projectListResponse = try? await classUnderTest.retrieveProjects(page: Page())
        XCTAssertEqual(projectListResponse?.items.count, 1)
        XCTAssertEqual(projectListResponse?.items[0].key, "my-key")
        XCTAssertEqual(projectListResponse?.items[0].name, "Some Name")
    }

    func test_retrieveProjects_ShouldReturnEmptyProjectResponseFromClientWhenNoOrgs() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: equal(to: .get), path: equal(to: "/organizations/search?member=true"), type: any())).thenReturn(OrganizationListResponse(items: []))
        }

        let classUnderTest = await SonarCloudClient(sonarHttpClient: sonarHttpClient)

        let projectListResponse = try? await classUnderTest.retrieveProjects(page: Page())
        XCTAssertEqual(projectListResponse?.items.count, 0)
    }

    func test_retrieveProjectStatusFor_ShouldReturnProjectStatusFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: any(), path: any(), type: any())).thenReturn(ProjectStatus(status: "PASS", newRatings: ProjectStatus.NewRatings(conditions: []), periods: []))
        }

        let classUnderTest = await SonarCloudClient(sonarHttpClient: sonarHttpClient)

        let projectStatus = try? await classUnderTest.retrieveProjectStatusFor(projectKey: "")
        XCTAssertEqual(projectStatus?.status, "PASS")
    }
}
