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

    func retrieveIssues(projectKey _: String) async throws -> [Issue] {
        [Issue()]
    }

    func retrieveProjects(page _: Page) async throws -> ProjectListResponse {
        try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/components/search?qualifiers=TRK")
    }

    func retrieveProjectStatusFor(projectKey: String) async throws -> ProjectStatus {
        try await sonarHttpClient.call(baseUrl: baseUrl, apiKey: apiKey, method: .get, path: "/api/qualitygates/project_status?projectKey=\(projectKey)")
    }
}
