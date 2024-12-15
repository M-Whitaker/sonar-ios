//
//  BranchSelectionView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 14/12/2024.
//
import SwiftUI

struct BranchSelectionView: View {
    @State private var searchText = ""

    let branches: [ProjectBranch]
    @Binding var showingPopover: Bool

    var body: some View {
        NavigationStack {
            List {
                ForEach(branches) { branch in
                    Button {} label: {
                        HStack {
                            Text(branch.name)
                            if branch.isMain {
                                Image(systemName: "lanyardcard.fill")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Choose Branch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingPopover = false
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Find a branch"))
            .onSubmit(of: .search) {
                print("fetch data from server to refresh with full search query")
            }
        }
    }
}
