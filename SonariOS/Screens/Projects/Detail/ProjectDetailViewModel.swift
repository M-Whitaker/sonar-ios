//
//  ProjectDetailViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 07/12/2024.
//
import Factory
import Foundation
import SwiftUI

class ProjectDetailViewModel: ObservableObject {
    @Injected(\.sonarClientFactory) var sonarClientFactory

    @Published var branches: [ProjectBranch] = []
    @Published var mainBranch: ProjectBranch?
    @Published var techDept: Int = 0

    @MainActor
    func refreshData(projectKey: String) async throws {
        let effort = try await sonarClientFactory.current.retrieveEffort(projectKey: projectKey)
        techDept = effort.effortTotal
        branches = try await sonarClientFactory.current.retrieveBranches(projectKey: projectKey)
        for branch in branches where branch.isMain {
            mainBranch = branch
        }
    }
}
