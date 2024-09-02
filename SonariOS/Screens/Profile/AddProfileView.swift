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
            }.onChange(of: viewModel.name) {
                viewModel.formValidate()
            }
            Picker("Account Type", selection: $viewModel.userDefaultsType) {
                ForEach(UserDefaultsType.allCases) { option in
                    Text(String(describing: option))
                }
            }.onChange(of: viewModel.userDefaultsType) {
                viewModel.formValidate()
            }
            if viewModel.userDefaultsType == .sonarQube {
                TextField(text: $viewModel.baseUrl) {
                    Text("Base URL")
                }
                .keyboardType(.URL)
                .textContentType(.URL)
                .textInputAutocapitalization(.never)
                .onChange(of: viewModel.baseUrl) {
                    viewModel.formValidate()
                }
            }
            TextField(text: $viewModel.apiKey) {
                Text("API Key")
            }.onChange(of: viewModel.apiKey) {
                viewModel.formValidate()
            }
        }
        .navigationTitle("Create Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                viewModel.formSubmit()
            } label: {
                Text("Add")
            }
            .disabled(!viewModel.valid)
        }
    }
}

// #Preview {
//  AddProfileView()
// }
