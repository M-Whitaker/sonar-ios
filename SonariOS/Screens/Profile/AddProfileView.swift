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
  @State var apiKey: String = ""
  
  var body: some View {
    VStack {
      TextField(text: $apiKey) {
        Text("API Key")
      }
      Picker("Account Type", selection: $userDefaultsType) {
          ForEach(UserDefaultsType.allCases) { option in
              Text(String(describing: option))
          }
      }
      .pickerStyle(.wheel)
      Button {
        var sonarUserDefaults: (any SonarUserDefaults)? = nil
        if userDefaultsType == .sonarType {
          sonarUserDefaults = SonarTypeUserDefaults()
        } else if userDefaultsType == .sonarCloud {
          sonarUserDefaults = SonarCloudUserDefaults()
        }
        guard var userDefaults = sonarUserDefaults else {
          return
        }
        
        userDefaults.id = "suite-name"
        userDefaults.userDefaults = UserDefaults(suiteName: userDefaults.id)
        profiles.append(userDefaults as! SonarTypeUserDefaults)
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
