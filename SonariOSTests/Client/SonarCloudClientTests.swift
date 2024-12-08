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
    func test_retrieveIssues_ShouldReturnListOfIssuesFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: equal(to: .get), path: equal(to: "/issues/search?assignees=__me__&p=1&ps=100"), type: any())).thenReturn(IssueListResponse(items: [Issue(key: "my-key", rule: "rule:12345", severity: "", component: "")]))
        }
        let classUnderTest = await SonarCloudClient(sonarHttpClient: sonarHttpClient)

        let issues = try? await classUnderTest.retrieveIssues(page: Page())
        XCTAssertEqual(issues?.items.count, 1)
        XCTAssertEqual(issues?.items[0].key, "my-key")
        XCTAssertEqual(issues?.items[0].rule, "rule:12345")
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

    func test_retrieveCurrentUser_ShouldReturnCurrentUserFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: any(), path: equal(to: "/users/current"), type: any())).thenReturn(User(name: "My Name", email: "my.name@example.com"))
        }
        let classUnderTest = await SonarCloudClient(sonarHttpClient: sonarHttpClient)
        let currentUser = try? await classUnderTest.retrieveCurrentUser()
        XCTAssertEqual(currentUser?.name, "My Name")
        XCTAssertEqual(currentUser?.email, "my.name@example.com")
    }

    func test_retrieveBranches_ShouldReturnBranchesFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: any(), path: equal(to: "/project_branches/list?project=my-project-key"), type: any())).thenReturn(ProjectBranchesResponse(branches: [ProjectBranch(name: "my-branch-name", isMain: true, status: ProjectBranchStatus(qualityGateStatus: "TRUE", bugs: 1, vulnerabilities: 2, codeSmells: 3), analysisDate: Date())]))
        }
        let classUnderTest = await SonarCloudClient(sonarHttpClient: sonarHttpClient)
        let branches = try? await classUnderTest.retrieveBranches(projectKey: "my-project-key")
        XCTAssertEqual(branches?.first?.name, "my-branch-name")
        XCTAssertTrue((branches?.first?.isMain) != nil)
        XCTAssertEqual(branches?.first?.status, ProjectBranchStatus(qualityGateStatus: "TRUE", bugs: 1, vulnerabilities: 2, codeSmells: 3))
    }

    func test_retrieveEffort_ShouldReturnEffortFromClient() async {
        let sonarHttpClient = MockSonarHttpClient()
        stub(sonarHttpClient) { stub in
            when(stub.call(baseUrl: any(), apiKey: any(), method: any(), path: equal(to: "/issues/search?projects=my-project-key&s=FILE_LINE&issueStatuses=CONFIRMED%2COPEN&ps=1"), type: any())).thenReturn(Effort(effortTotal: 15))
        }
        let classUnderTest = await SonarCloudClient(sonarHttpClient: sonarHttpClient)
        let effort = try? await classUnderTest.retrieveEffort(projectKey: "my-project-key")
        XCTAssertEqual(effort?.effortTotal, 15)
    }
}
