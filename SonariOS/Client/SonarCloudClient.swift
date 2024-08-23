//
//  SonarCloudClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation

class SonarCloudClient: SonarClient {
    private static let SONAR_CLOUD_BASE_URL = "sonarcloud.io/api"

    var baseUrl: String
    @Preference(\.sonarCloudApiKey) var apiKey: String

    convenience init() {
        self.init(baseUrl: SonarCloudClient.SONAR_CLOUD_BASE_URL)
    }

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func retrieveIssues(projectKey _: String) async throws -> [Issue] {
        [Issue()]
    }

    func retrieveProjects() async throws -> APIListResponse<Project> {
        print("Retriving projects from sonar cloud...")
        return try await call(method: .get, path: "/projects/search?organization=m-whitaker")
    }
}
