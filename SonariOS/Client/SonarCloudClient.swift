//
//  SonarCloudClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation

class SonarCloudClient: SonarClient {
    private static let kSonarCloudBaseUrl = "sonarcloud.io/api"

    @UserScopedPreference(\.apiKey) var apiKey: String

    var sonarHttpClient: SonarHttpClient

    init(sonarHttpClient: SonarHttpClient) {
        self.sonarHttpClient = sonarHttpClient
    }

    func retrieveProjects(page: Page) async throws -> ProjectListResponse {
        let orgs: OrganizationListResponse = try await sonarHttpClient.call(baseUrl: SonarCloudClient.kSonarCloudBaseUrl, apiKey: apiKey, method: .get, path: "/organizations/search?member=true")
        if let org = orgs.items.find(at: 0) {
            return try await sonarHttpClient.call(baseUrl: SonarCloudClient.kSonarCloudBaseUrl, apiKey: apiKey, method: .get, path: "/components/search?organization=\(org.key)&p=\(page.pageIndex)&ps=\(page.pageSize)")
        } else {
            return ProjectListResponse()
        }
    }

    func retrieveProjectStatusFor(projectKey: String) async throws -> ProjectStatus {
        try await sonarHttpClient.call(baseUrl: SonarCloudClient.kSonarCloudBaseUrl, apiKey: apiKey, method: .get, path: "/qualitygates/project_status?projectKey=\(projectKey)")
    }

    func retrieveCurrentUser() async throws -> User {
        try await sonarHttpClient.call(baseUrl: SonarCloudClient.kSonarCloudBaseUrl, apiKey: apiKey, method: .get, path: "/users/current")
    }

    func retrieveIssues(page: Page) async throws -> IssueListResponse {
        try await sonarHttpClient.call(baseUrl: SonarCloudClient.kSonarCloudBaseUrl, apiKey: apiKey, method: .get, path: "/issues/search?assignees=__me__&p=\(page.pageIndex)&ps=\(page.pageSize)")
    }

    func retrieveBranches(projectKey: String) async throws -> [ProjectBranch] {
        let res: ProjectBranchesResponse = try await sonarHttpClient.call(baseUrl: SonarCloudClient.kSonarCloudBaseUrl, apiKey: apiKey, method: .get, path: "/project_branches/list?project=\(projectKey)")
        return res.branches
    }

    func retrieveEffort(projectKey: String) async throws -> Effort {
        try await sonarHttpClient.call(baseUrl: SonarCloudClient.kSonarCloudBaseUrl, apiKey: apiKey, method: .get, path: "/issues/search?projects=\(projectKey)&s=FILE_LINE&issueStatuses=CONFIRMED%2COPEN&ps=1")
    }
}
