//
//  ProfilePicker.swift
//  SonariOS
//
//  Created by Matt Whitaker on 27/08/2024.
//

import Factory
import SwiftUI

struct ProfilePicker: View {
    @Preference(\.profiles) var profiles
    @Preference(\.currentProfileIdx) var currentProfileIdx

    var body: some View {
        List {
            ForEach(Array(profiles.enumerated()), id: \.offset) { idx, profile in
                Button {
                    currentProfileIdx = idx
                    print(currentProfileIdx)
                } label: {
                    Text("\(profile.userDefaults.name)")
                }
            }
            .onDelete(perform: delete)
        }
        NavigationLink(destination: AddProfileView()) { Text("Add Accounts") }
    }

    func delete(atOffsets: IndexSet) {
        // TODO: Call delete on the profile associated with the row
        profiles.remove(atOffsets: atOffsets)
    }
}

#Preview {
    ProfilePicker()
}
