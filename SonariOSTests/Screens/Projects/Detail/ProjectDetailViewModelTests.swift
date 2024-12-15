//
//  ProjectDetailViewModelTests.swift
//  SonariOS
//
//  Created by Matt Whitaker on 08/12/2024.
//

import Cuckoo
@testable import SonariOS
import XCTest

import Factory

final class ProjectDetailViewModelTests: XCTestCase {
    let mockSonarHttpClient = MockSonarHttpClient()

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_refreshData_ShouldPopulateStateWhenSuccessful() async throws {
        let sonarClient = await MockSonarCloudClient(sonarHttpClient: mockSonarHttpClient)

        let date = Date()

        stub(sonarClient) { stub in
            when(stub.retrieveBranches(projectKey: "my-project")).thenReturn([ProjectBranch(name: "feature/my-feature", isMain: false, status: nil, analysisDate: date, branchId: "f4f5d991-a87a-4ba0-82d4-eba7335f310e"), ProjectBranch(name: "master", isMain: true, status: ProjectBranchStatus(qualityGateStatus: "PASS", bugs: 1, vulnerabilities: 2, codeSmells: 3), analysisDate: date, branchId: "5adc9bee-ca3c-4ed5-8f54-8df956629a54")])
            when(stub.retrieveEffort(projectKey: "my-project")).thenReturn(Effort(effortTotal: 5))
        }

        let sonarClientFactory = MockSonarClientFactory()
        stub(sonarClientFactory) { stub in
            when(stub.current.get).thenReturn(sonarClient)
        }

        Container.shared.sonarClientFactory.register { sonarClientFactory }

        let classUnderTest = ProjectDetailViewModel()
        try await classUnderTest.refreshData(projectKey: "my-project")

        XCTAssertEqual(classUnderTest.state, .loaded(ProjectDetailViewModelState(branches: [ProjectBranch(name: "feature/my-feature", isMain: false, status: nil, analysisDate: date, branchId: "f4f5d991-a87a-4ba0-82d4-eba7335f310e"), ProjectBranch(name: "master", isMain: true, status: ProjectBranchStatus(qualityGateStatus: "PASS", bugs: 1, vulnerabilities: 2, codeSmells: 3), analysisDate: date, branchId: "5adc9bee-ca3c-4ed5-8f54-8df956629a54")], mainBranch: ProjectBranch(name: "master", isMain: true, status: ProjectBranchStatus(qualityGateStatus: "PASS", bugs: 1, vulnerabilities: 2, codeSmells: 3), analysisDate: date, branchId: "5adc9bee-ca3c-4ed5-8f54-8df956629a54"), techDept: .seconds(5 * 60))))
    }
}