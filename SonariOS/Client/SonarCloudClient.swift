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
    @UserScopedPreference(\.apiKey) var apiKey: String

    convenience init() {
        self.init(baseUrl: SonarCloudClient.SONAR_CLOUD_BASE_URL)
    }

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func retrieveIssues(projectKey _: String) async throws -> [Issue] {
        [Issue()]
    }

    func retrieveProjects(page: Page) async throws -> ProjectListResponse {
        print("Retriving projects from sonar cloud...")
        let orgs: OrganizationListResponse = try await call(method: .get, path: "/organizations/search?member=true")
        if let org = orgs.items.find(at: 0) {
            return try await call(method: .get, path: "/components/search?organization=\(org.key)&p=\(page.pageIndex)&ps=\(page.pageSize)")
        } else {
            return ProjectListResponse()
        }
    }
}
