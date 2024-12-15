//
//  SettingsView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/08/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()

    @Preference(\.profiles) var profiles
    @Preference(\.currentProfileIdx) var currentProfileIdx

    var body: some View {
        Form {
            if !profiles.isEmpty {
                Group {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                            Text("\(viewModel.name)")
                                .font(.title)
                            Text("\(viewModel.email)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                Section(header: Text("Profiles")) {
                    Text(profiles[currentProfileIdx].userDefaults.type.description)
                    SecureTextField("Required", prompt: $profiles[currentProfileIdx].userDefaults.apiKey)
                }
            }
            Section(header: Text("Accounts")) {
                NavigationLink(destination: ProfilePicker()) { Text("Manage Accounts") }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(GroupedListStyle())
        .onAppear {
            Task {
                try await viewModel.retrieveUserInfo()
            }
        }
    }
}

#Preview {
    SettingsView()
}
