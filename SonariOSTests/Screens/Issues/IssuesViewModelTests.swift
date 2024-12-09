//
//  IssuesViewModelTests.swift
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Cuckoo
@testable import SonariOS
import XCTest

import Factory

final class IssuesViewModelTests: XCTestCase {
    let mockSonarHttpClient = MockSonarHttpClient()

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_GetIssues_Page_ShouldRetrieveIssueListFromSonarClient() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)
        createStubClient(issueKey: "my-issue-1", mockClient: sonarClient)

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = IssuesViewModel()

        let expectedIssues = [Issue(key: "my-issue-1", rule: "rule:0987", severity: "HIGH", component: "my-project")]
        await classUnderTest.getIssues()
        XCTAssertEqual(classUnderTest.state, .loaded(expectedIssues))
    }

    func test_GetIssues_Page_ShouldErrorStateWhenErrorFromSonarClient() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)
        stub(sonarClient) { stub in
            when(stub.retrieveIssues(page: any())).thenThrow(APIError.httpCode(.forbidden))
        }

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = IssuesViewModel()

        await classUnderTest.getIssues()
        XCTAssertEqual(classUnderTest.state, .failed(APIError.httpCode(.forbidden)))
    }

    func test_GetIssues_Int_ShouldRetrieveProjectListFromSonarClientIfThresholdMeetAndMoreItemsRemaining() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)
        createStubClient(issueKey: "my-issue-2", mockClient: sonarClient)

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let expectedProjects = [Issue(key: "my-issue-1", rule: "rule:0987", severity: "HIGH", component: "my-project"), Issue(key: "my-issue-2", rule: "rule:0987", severity: "HIGH", component: "my-project")]

        let classUnderTest = IssuesViewModel()
        classUnderTest.state = .loaded([Issue(key: "my-issue-1", rule: "rule:0987", severity: "HIGH", component: "my-project")])
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 5, total: 20)
        await classUnderTest.getIssues(index: 12)

        verify(sonarClient).retrieveIssues(page: equal(to: Page(pageIndex: 1, pageSize: 5, total: 20)))

        XCTAssertEqual(classUnderTest.state, .loaded(expectedProjects))
    }

    func test_GetIssues_Int_ShouldNotRetrieveIssueListFromSonarClientIfNoItemsLoaded() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)
        createStubClient(issueKey: "my-issue-1", mockClient: sonarClient)

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = IssuesViewModel()

        await classUnderTest.getIssues(index: 1)

        verifyNoMoreInteractions(sonarClient)
    }

    func test_GetIssues_Int_ShouldNotRetrieveIssueListFromSonarClientIfThresholdNotMeet() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)
        createStubClient(issueKey: "my-issue-1", mockClient: sonarClient)

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = IssuesViewModel()
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 0, total: 0)

        await classUnderTest.getIssues(index: 1)

        verifyNoMoreInteractions(sonarClient)
    }

    func test_GetIssues_Int_ShouldNotRetrieveIssueListFromSonarClientIfThresholdMeetButMoreItemsNotRemaining() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)
        createStubClient(issueKey: "my-issue-1", mockClient: sonarClient)

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = IssuesViewModel()
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 0, total: 0)

        await classUnderTest.getIssues(index: 12)

        verifyNoMoreInteractions(sonarClient)
    }

    func test_ResetIssues_ShouldResetItemsLoadedCountAndPageAndState() async {
        let classUnderTest = IssuesViewModel()
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 0, total: 0)
        classUnderTest.state = .isLoading

        await classUnderTest.resetIssues()

        XCTAssertNil(classUnderTest.itemsLoadedCount)
        XCTAssertNil(classUnderTest.page)
        XCTAssertEqual(classUnderTest.state, .loaded([]))
    }

    private func createStubClient(issueKey: String, mockClient: MockSonarCloudClient) {
        stub(mockClient) { stub in
            when(stub.retrieveIssues(page: any())).thenReturn(IssueListResponse(items: [Issue(key: issueKey, rule: "rule:0987", severity: "HIGH", component: "my-project")]))
        }
    }

    private func buildProjectStatus() -> ProjectStatus {
        ProjectStatus(status: "", newRatings: buildRatingCondition(), periods: [ProjectStatus.Period(index: 0, mode: "mode", date: "01-02-2024")])
    }

    private func buildRatingCondition() -> ProjectStatus.NewRatings {
        .init(conditions: [])
    }
}
