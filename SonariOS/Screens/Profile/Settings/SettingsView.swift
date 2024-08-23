//
//  SettingsView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/08/2024.
//

import SwiftUI

struct SettingsView: View {
    @Preference(\.sonarCloudApiKey) var apiKey

    var body: some View {
        List {
            Section {
                Text("One of One")
                TextField("API Key", text: $apiKey)
            }
            Section {
                Text("One of Two")
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
