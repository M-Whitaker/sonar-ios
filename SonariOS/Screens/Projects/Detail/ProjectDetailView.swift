//
//  ProjectDetailView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 07/12/2024.
//

import SwiftUI

struct ProjectDetailView: View {
    @StateObject var viewModel = ProjectDetailViewModel()

    var project: Project

    var body: some View {
        ScrollView {
            if let mainBranch = viewModel.mainBranch, let projectStatus = project.status {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(project.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text(projectStatus.status == "OK" ? "Passed" : "Failed")
                            .font(.headline)
                            .foregroundColor(projectStatus.status == "OK" ? .green : .red)
                    }
                    .padding(.bottom, 10)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Project Key: \(project.key)")
                                .font(.subheadline)
                            Text("Technical Debt: \(viewModel.techDept)min effort")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Metrics:")
                            .font(.headline)
                        HStack {
                            if let bugs = mainBranch.status?.bugs {
                                Text("Bugs: \(bugs)")
                            }
                            Spacer()
                            if let vulnerabilities = mainBranch.status?.vulnerabilities {
                                Text("Vulnerabilities: \(vulnerabilities)")
                            }
                        }
                        .font(.body)
                        .foregroundColor(.gray)

                        HStack {
                            if let codeSmells = mainBranch.status?.codeSmells {
                                Text("Code Smells: \(codeSmells)")
                            }
                            Spacer()
                            Text("Test Coverage: \(String(format: "%.2f", Double(projectStatus.newRatings.coverage.actualValue) ?? 0))")
                        }
                        .font(.body)
                        .foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)

                    HStack {
                        Text("Last Analysis Date:")
                            .font(.subheadline)
                        Spacer()
                        Text(mainBranch.analysisDate, style: .date)
                            .font(.subheadline)
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Project Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                try await viewModel.refreshData(projectKey: project.key)
            }
        }
    }
}
