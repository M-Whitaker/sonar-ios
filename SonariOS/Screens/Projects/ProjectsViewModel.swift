//
//  ProjectsViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Factory
import Foundation

enum ViewLoadingState<T> {
    case isLoading
    case loaded(T)
    case failed(Error)
}

class ProjectsViewModel: ObservableObject {
    @Published var state: ViewLoadingState<[Project]> = .isLoading

    @MainActor
    func getProjects() async {
        do {
            let projects = try await StaticSonarClient.current.retrieveProjects()
            print(projects.items)
            state = .loaded(projects.items)
        } catch {
            print("Some error in viewModel")
            state = .failed(error)
        }
    }
}
