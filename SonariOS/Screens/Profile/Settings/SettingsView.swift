//
//  SettingsView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/08/2024.
//

import SwiftUI

struct SettingsView: View {
    @Preference(\.profiles) var profiles
    @Preference(\.currentProfileIdx) var currentProfileIdx

    var body: some View {
        List {
            if !profiles.isEmpty {
                Section {
                    // Text("Profile Type: \($profiles[currentProfileIdx].type)")
                    TextField(text: $profiles[currentProfileIdx].userDefaults.apiKey) {
                        Text("API KEY")
                    }
                }
            }
            Section {
                NavigationLink(destination: ProfilePicker()) { Text("Manage Accounts") }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(GroupedListStyle())
    }
}

#Preview {
    SettingsView()
}
