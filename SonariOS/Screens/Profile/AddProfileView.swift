//
//  AddProfileView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 28/08/2024.
//

import SwiftUI

struct AddProfileView: View {
  
  @Preference(\.profiles) var profiles
  @State var userDefaultsType: UserDefaultsType = .sonarCloud
  @State var name: String = ""
  @State var apiKey: String = ""
  @State var baseUrl: String = ""
  
  var body: some View {
    Form {
      TextField(text: $name) {
        Text("Name")
      }
      Picker("Account Type", selection: $userDefaultsType) {
          ForEach(UserDefaultsType.allCases) { option in
              Text(String(describing: option))
          }
      }
      .pickerStyle(.wheel)
      if userDefaultsType == .sonarQube {
        TextField(text: $baseUrl) {
          Text("Base URL")
        }
      }
      TextField(text: $apiKey) {
        Text("API Key")
      }
      Button {
        // TODO: Need some validation
        var sonarUserDefaults: SonarUserDefaults? = nil
        if userDefaultsType == .sonarQube {
          sonarUserDefaults = SonarQubeUserDefaults(id: "\(Bundle.main.artifactName).\(name)", name: name, apiKey: apiKey, baseUrl: baseUrl)
        } else if userDefaultsType == .sonarCloud {
          sonarUserDefaults = SonarCloudUserDefaults(id: "\(Bundle.main.artifactName).\(name)", name: name, apiKey: apiKey)
        }
        guard let userDefaults = sonarUserDefaults else {
          return
        }
        userDefaults.userDefaults = UserDefaults(suiteName: userDefaults.id)
        profiles.append(userDefaults)
      } label: {
        Text("Add")
      }
    }
    .navigationTitle("Create Profile")
  }
}

//#Preview {
//  AddProfileView()
//}
