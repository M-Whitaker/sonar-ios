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

    func test_GetProjects_Page_ShouldRetrieveProjectListFromSonarClient() async throws {
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

    func test_GetProjects_Page_ShouldErrorStateWhenErrorFromSonarClient() async throws {
        let sonarClient = await MockSonarCloudClient()
        stub(sonarClient) { stub in
            when(stub.retrieveProjects(page: any())).thenThrow(APIError.httpCode(.forbidden))
        }

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = ProjectsViewModel()

        await classUnderTest.getProjects()
        XCTAssertEqual(classUnderTest.state, .failed(APIError.httpCode(.forbidden)))
    }

    func test_GetProjects_Int_ShouldRetrieveProjectListFromSonarClientIfThresholdMeetAndMoreItemsRemaining() async throws {
        let sonarClient = await MockSonarCloudClient()
        stub(sonarClient) { stub in
            when(stub.retrieveProjects(page: any())).thenReturn(ProjectListResponse(items: [Project(key: "my-project-2")]))
        }

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let expectedProjects = [Project(key: "my-project-1"), Project(key: "my-project-2")]

        let classUnderTest = ProjectsViewModel()
        classUnderTest.state = .loaded([Project(key: "my-project-1")])
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 5, total: 20)
        await classUnderTest.getProjects(index: 12)

        verify(sonarClient).retrieveProjects(page: equal(to: Page(pageIndex: 1, pageSize: 5, total: 20)))

        XCTAssertEqual(classUnderTest.state, .loaded(expectedProjects))
    }

    func test_GetProjects_Int_ShouldNotRetrieveProjectListFromSonarClientIfNoItemsLoaded() async throws {
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

        await classUnderTest.getProjects(index: 1)

        verifyNoMoreInteractions(sonarClient)
    }

    func test_GetProjects_Int_ShouldNotRetrieveProjectListFromSonarClientIfThresholdNotMeet() async throws {
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
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 0, total: 0)

        await classUnderTest.getProjects(index: 1)

        verifyNoMoreInteractions(sonarClient)
    }

    func test_GetProjects_Int_ShouldNotRetrieveProjectListFromSonarClientIfThresholdMeetButMoreItemsNotRemaining() async throws {
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
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 0, total: 0)

        await classUnderTest.getProjects(index: 12)

        verifyNoMoreInteractions(sonarClient)
    }

    func test_ResetProjects_ShouldResetItemsLoadedCountAndPageAndState() {
        let classUnderTest = ProjectsViewModel()
        classUnderTest.itemsLoadedCount = 15
        classUnderTest.page = Page(pageIndex: 0, pageSize: 0, total: 0)
        classUnderTest.state = .isLoading

        classUnderTest.resetProjects()

        XCTAssertNil(classUnderTest.itemsLoadedCount)
        XCTAssertNil(classUnderTest.page)
        XCTAssertEqual(classUnderTest.state, .loaded([]))
    }
}