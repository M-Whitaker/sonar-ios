//
//  SonarQubeClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation
import HTTPTypes

class SonarQubeClient: SonarClient {
    @SonarQubeUserScopedPreference(\.baseUrl) var baseUrl: String
    @UserScopedPreference(\.apiKey) var apiKey: String

    var sonarHttpClient: SonarHttpClient

    init(sonarHttpClient: SonarHttpClient) {
        self.sonarHttpClient = sonarHttpClient
    }

    func retrieveProjects(page _: Page) async throws -> ProjectListResponse {
        try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/components/search?qualifiers=TRK")
    }

    func retrieveProjectStatusFor(projectKey: String) async throws -> ProjectStatus {
        try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/qualitygates/project_status?projectKey=\(projectKey)")
    }

    func retrieveCurrentUser() async throws -> User {
        try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/users/current")
    }

    func retrieveIssues(page: Page) async throws -> IssueListResponse {
        try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/issues/search?assignees=__me__&p=\(page.pageIndex)&ps=\(page.pageSize)")
    }

    func retrieveBranches(projectKey: String) async throws -> [ProjectBranch] {
        let res: ProjectBranchesResponse = try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/project_branches/list?project=\(projectKey)")
        return res.branches
    }

    func retrieveEffort(projectKey: String) async throws -> Effort {
        try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/issues/search?components=\(projectKey)&s=FILE_LINE&issueStatuses=CONFIRMED%2COPEN&ps=1")
    }

    func retreivePullRequests(projectKey: String) async throws -> [PullRequest] {
        let res: ProjectPullRequestsResponse = try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/project_pull_requests/list?project=\(projectKey)")
        return res.pullRequests
    }
}
