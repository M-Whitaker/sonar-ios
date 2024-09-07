//
//  ProjectsView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/08/2024.
//

import SwiftUI

struct ProjectsView: View {
    @StateObject var viewModel = ProjectsViewModel()

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .isLoading:
                loadingView()
            case let .loaded(projects):
                loadedView(projects: projects)
            case let .failed(error):
                failedView(error)
            }
        }
        .onAppear {
            Task {
                await getProjects()
            }
        }
    }

    private func loadedView(projects: [Project]) -> some View {
        List {
            ForEach(Array(projects.enumerated()), id: \.offset) { idx, project in
                projectSummary(project: project, index: idx)
            }
        }
        .navigationTitle("Projects")
        .overlay {
            if viewModel.newItemsLoading {
                ProgressView()
            }
        }
        .refreshable {
            viewModel.resetProjects()
            await getProjects()
        }
    }

    private func projectSummary(project: Project, index: Int) -> some View {
        Text(project.key)
            .task {
                await viewModel.getProjects(index: index)
            }
    }

    private func getProjects() async {
        await viewModel.getProjects()
    }
}

// MARK: - Loading Content

private extension ProjectsView {
    func loadingView() -> some View {
        AnyView(ProgressView().padding())
    }

    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            await self.getProjects()
        })
    }
}
