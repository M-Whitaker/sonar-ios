//
//  ProjectsView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/08/2024.
//

import SwiftUI

struct ProjectsView: View {
    @StateObject var viewModel = ProjectsViewModel()
    @State var projects: [Project] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(projects) { project in
                    Text(project.key)
                }
            }
            .onAppear {
                Task {
                    await getProjects()
                }
            }
            .navigationTitle("Projects")
            .refreshable {
                await getProjects()
            }
        }
    }

    private func getProjects() async {
        projects = await viewModel.getProjects()
    }
}
