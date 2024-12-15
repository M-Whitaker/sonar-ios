//
//  PullRequestSelectionViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 15/12/2024.
//

import Factory
import SwiftUI

class PullRequestSelectionViewModel: ObservableObject {
    @Published var pullRequests: [PullRequest] = []

    @Injected(\.sonarClientFactory) var sonarClientFactory

    @MainActor
    public func retrievePullRequests(projectKey: String) async throws {
        pullRequests = try await sonarClientFactory.current.retreivePullRequests(projectKey: projectKey)
    }
}
