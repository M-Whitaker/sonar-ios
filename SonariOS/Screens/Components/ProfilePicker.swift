//
//  ProfilePicker.swift
//  SonariOS
//
//  Created by Matt Whitaker on 27/08/2024.
//

import SwiftUI

struct ProfilePicker: View {
  
  @Preference(\.profiles) var profiles
  @Preference(\.currentProfileIdx) var currentProfileIdx
  
  var body: some View {
    VStack {
      List {
        ForEach(profiles.indices) { idx in
            Button {
              currentProfileIdx = idx
              print(currentProfileIdx)
            } label: {
              Text("\(profiles[idx].apiKey)")
            }

          }
      }
      NavigationLink(destination: AddProfileView()) {Text("Add Accounts")}
    }
    
  }
}

#Preview {
  ProfilePicker()
}
