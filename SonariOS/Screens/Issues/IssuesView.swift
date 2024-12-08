//
//  IssuesView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 07/12/2024.
//

import SwiftUI

struct IssuesView: View {
    @StateObject var viewModel = IssuesViewModel()

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .isLoading:
                loadingView()
            case let .loaded(issues):
                loadedView(issues: issues)
            case let .failed(error):
                failedView(error)
            }
        }
        .onAppear {
            Task {
                await getIssues()
            }
        }
    }

    private func loadedView(issues: [Issue]) -> some View {
        List {
            ForEach(Array(issues.enumerated()), id: \.offset) { idx, issue in
                issueSummary(issue: issue, index: idx)
            }
        }
        .navigationTitle("Issues")
        .overlay {
            if viewModel.newItemsLoading {
                ProgressView()
            }
        }
        .refreshable {
            viewModel.resetIssues()
            await getIssues()
        }
    }

    private func issueSummary(issue: Issue, index: Int) -> some View {
        Text("\(issue.rule) | \(issue.component.split(separator: ":").last ?? "Unknown File Path")")
            .task {
                await viewModel.getIssues(index: index)
            }
    }

    private func getIssues() async {
        await viewModel.getIssues()
    }
}

// MARK: - Loading Content

private extension IssuesView {
    func loadingView() -> some View {
        AnyView(ProgressView().padding())
    }

    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            await self.getIssues()
        })
    }
}
