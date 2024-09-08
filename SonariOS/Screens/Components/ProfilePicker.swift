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
                    HStack {
                        Text("\(profile.userDefaults.name)")
                        if idx == currentProfileIdx {
                            Spacer()
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NavigationLink(destination: AddProfileView()) { Text("Add") }
        }
    }

    func delete(atOffsets: IndexSet) {
        profiles.remove(atOffsets: atOffsets)
    }
}

#Preview {
    ProfilePicker()
}
