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

    @Published var state: ViewLoadingState<ProjectDetailViewModelState> = .isLoading

    @MainActor
    func refreshData(projectKey: String) async throws {
        let effort = try await sonarClientFactory.current.retrieveEffort(projectKey: projectKey)
        let techDept = effort.effortTotal
        let branches = try await sonarClientFactory.current.retrieveBranches(projectKey: projectKey)
        var mainBranch: ProjectBranch?
        for branch in branches where branch.isMain {
            mainBranch = branch
        }
        state = .loaded(ProjectDetailViewModelState(branches: branches, mainBranch: mainBranch, techDept: .seconds(techDept * 60)))
    }
}

struct ProjectDetailViewModelState: Equatable {
    var branches: [ProjectBranch] = []
    var mainBranch: ProjectBranch?
    var techDept: Duration
}
