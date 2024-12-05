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

    func retrieveIssues(projectKey _: String) async throws -> [Issue] {
        [Issue()]
    }

    func retrieveProjects(page: Page) async throws -> ProjectListResponse {
        print("Retriving projects from sonar cloud...")
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
}
