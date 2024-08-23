//
//  ProfileView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/08/2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("First part")
            }
            .navigationTitle("Profile")
            .toolbar {
                NavigationLink(destination: SettingsView()) { Image(systemName: "gearshape") }
            }
        }
    }
}

#Preview {
    ProfileView()
}
