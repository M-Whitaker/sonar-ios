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

    func retrieveIssues(projectKey _: String) async throws -> [Issue] {
        [Issue()]
    }

    func retrieveProjects() async throws -> APIListResponse<Project> {
        print("Retriving projects from sonarqube url \(baseUrl)...")
        throw URLError(.unknown)
    }
}
