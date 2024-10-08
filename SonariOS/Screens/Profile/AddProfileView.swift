//
//  AddProfileView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 28/08/2024.
//

import SwiftUI

struct AddProfileView: View {
    @ObservedObject var viewModel = AddProfileViewModel()

    var body: some View {
        Form {
            TextField(text: $viewModel.name) {
                Text("Name")
            }
            accountTypePicker()
            if viewModel.userDefaultsType == .sonarQube {
                baseUrlField()
            }
            TextField(text: $viewModel.apiKey) {
                Text("API Key")
            }
            .textContentType(.password)
            .textInputAutocapitalization(.never)
        }
        .navigationTitle("Create Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                viewModel.formSubmit()
            } label: {
                Text("Add")
            }
        }
    }

    private func accountTypePicker() -> some View {
        Picker("Account Type", selection: $viewModel.userDefaultsType) {
            ForEach(UserDefaultsType.allCases) { option in
                Text(String(describing: option))
            }
        }
    }

    private func baseUrlField() -> some View {
        TextField(text: $viewModel.baseUrl) {
            Text("Base URL")
        }
        .keyboardType(.URL)
        .textContentType(.URL)
        .textInputAutocapitalization(.never)
    }
}

// #Preview {
//  AddProfileView()
// }
