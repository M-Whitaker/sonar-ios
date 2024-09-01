//
//  ProjectsViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Factory
import Foundation

class ProjectsViewModel: ObservableObject {
    func getProjects() async -> [Project] {
        do {
            let projects = try await StaticSonarClient.current.retrieveProjects()
            print(projects)
            return projects.components
        } catch {
            print("Some error in viewModel")
            return []
        }
    }
}
