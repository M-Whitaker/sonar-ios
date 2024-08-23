//
//  SonarTypeClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation
import HTTPTypes

class SonarTypeClient: SonarClient {
    var baseUrl: String
    var apiKey: String = ""

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func retrieveIssues(projectKey _: String) async throws -> [Issue] {
        [Issue()]
    }

    func retrieveProjects() async throws -> APIListResponse<Project> {
        print("Retriving projects from sonar type...")
        throw URLError(.unknown)
    }
}
