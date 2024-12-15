//
//  PullRequestSelectionView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 15/12/2024.
//
import SwiftUI

struct PullRequestSelectionView: View {
    @State private var searchText = ""
    @StateObject var viewModel = PullRequestSelectionViewModel()

    let projectKey: String
    @Binding var showingPopover: Bool

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.pullRequests) { pullRequest in
                    Button {} label: {
                        HStack {
                            Text("#\(pullRequest.key)")
                            Text(pullRequest.title)
                        }
                    }
                }
            }
            .navigationTitle("Choose Pull Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingPopover = false
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Find a Pull Request"))
            .onSubmit(of: .search) {
                print("fetch data from server to refresh with full search query")
            }
        }
        .onAppear {
            Task {
                try await viewModel.retrievePullRequests(projectKey: projectKey)
            }
        }
    }
}
